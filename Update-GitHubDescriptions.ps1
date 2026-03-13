# Updates GitHub repo descriptions from local README.md in d:\Gorstak\*
$basePath = "d:\Gorstak"
$owner = "Gorstak-Zadar"

function Get-DescriptionFromReadme {
    param([string]$content)
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
