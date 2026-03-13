# Updates GitHub repo descriptions from README.md
# Looks for <!-- description: ... --> first, then falls back to blockquote
$basePath = "d:\Gorstak"
$owner = "Gorstak-Zadar"

function Get-DescriptionFromReadme {
    param([string]$content)
    # 1. Explicit description (preferred)
    if ($content -match '(?s)<!--\s*description:\s*(.+?)-->') {
        $desc = $matches[1].Trim() -replace '\s+', ' '
        # GitHub rejects control/format and some Unicode; keep printable ASCII only
        $desc = ($desc -replace '[^\x20-\x7E]', '-').Trim() -replace '-+', '-' -replace '\s+', ' '
        if ($desc.Length -ge 10) {
            if ($desc.Length -gt 350) { $desc = $desc.Substring(0, 347) + "..." }
            return $desc
        }
    }
    # 2. Fallback: first blockquote or paragraph
    $lines = $content -split "`n"
    $desc = ""
    foreach ($line in $lines) {
        $t = $line.Trim()
        if ($t -eq "") { continue }
        if ($t -match '^#{1,6}\s') { continue }
        if ($t -match '^>\s*(.+)$') { $desc = $matches[1]; break }
        if ($t -match '^[\[!`*]|^[-*+]\s') { continue }
        if ($t.Length -gt 15) { $desc = $t; break }
    }
    if (-not $desc) { return $null }
    $desc = $desc -replace '\*\*([^*]+)\*\*', '$1' -replace '\[([^\]]+)\]\([^)]+\)', '$1' -replace '`[^`]+`', ''
    $desc = ($desc.Trim() -replace '\s+', ' ')
    if ($desc.Length -lt 10) { return $null }
    $desc = ($desc -replace '[^\x20-\x7E]', '-').Trim() -replace '-+', '-' -replace '\s+', ' '
    if ($desc.Length -gt 350) { $desc = $desc.Substring(0, 347) + "..." }
    return $desc
}

$dirs = Get-ChildItem $basePath -Directory | Where-Object { $_.Name -ne ".git" }
$updated = 0
$skipped = 0

foreach ($dir in $dirs) {
    $readmePath = Join-Path $dir.FullName "README.md"
    if (-not (Test-Path $readmePath)) { $skipped++; continue }

    $content = Get-Content $readmePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { $skipped++; continue }

    $desc = Get-DescriptionFromReadme $content
    if (-not $desc) { $skipped++; continue }

    $fullName = "$owner/$($dir.Name)"
    $result = gh repo edit $fullName --description $desc 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] $($dir.Name)"
        $updated++
    } else {
        Write-Host "[SKIP] $($dir.Name): $result"
        $skipped++
    }
}

Write-Host "`nDone. Updated: $updated, Skipped: $skipped"
