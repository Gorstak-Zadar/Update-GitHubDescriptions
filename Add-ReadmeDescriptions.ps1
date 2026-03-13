# Adds <!-- description: ... --> to README.md in each repo
# Seeds from current GitHub description. Edit the comments to improve, then run Update-GitHubDescriptions.ps1
$basePath = "d:\Gorstak"
$owner = "Gorstak-Zadar"
$commentPrefix = "<!-- description: "
$commentSuffix = " -->"

$dirs = Get-ChildItem $basePath -Directory | Where-Object { $_.Name -ne ".git" }
$added = 0
$skipped = 0

foreach ($dir in $dirs) {
    $readmePath = Join-Path $dir.FullName "README.md"
    if (-not (Test-Path $readmePath)) { $skipped++; continue }

    $content = Get-Content $readmePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { $skipped++; continue }

    # Already has explicit description?
    if ($content -match '<!--\s*description:\s*.+?-->') { $skipped++; continue }

    # Get current GitHub description
    $fullName = "$owner/$($dir.Name)"
    $ghDesc = gh repo view $fullName --json description -q .description 2>$null
    if (-not $ghDesc) { $ghDesc = "" }

    $desc = $ghDesc.Trim()
    if ($desc.Length -lt 5) {
        # Fallback: first blockquote or paragraph (skip HTML, badges, lists)
        $lines = $content -split "`n"
        foreach ($line in $lines) {
            $t = $line.Trim()
            if ($t -eq "" -or $t -match '^#{1,6}\s' -or $t -match '^<') { continue }
            if ($t -match '^\[!?\]' -or $t -match '^[\[!`*]|^[-*+]\s') { continue }
            if ($t -match '^>\s*(.+)$') { $desc = $matches[1] -replace '\*\*([^*]+)\*\*', '$1'; break }
            if ($t.Length -gt 15) { $desc = $t; break }
        }
        $desc = ($desc -replace '\[([^\]]+)\]\([^)]+\)', '$1' -replace '`[^`]+`', '' -replace '\s+', ' ').Trim()
    }
    if ($desc.Length -lt 5) { $skipped++; continue }
    $desc = $desc -replace '-->', '-'  # avoid breaking HTML comment

    # Insert <!-- description: ... --> at the top
    $block = "$commentPrefix$desc$commentSuffix`n`n"
    $newContent = $block + $content.TrimStart()
    [System.IO.File]::WriteAllText($readmePath, $newContent, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[ADD] $($dir.Name)"
    $added++
}

Write-Host "`nDone. Added to $added READMEs, Skipped: $skipped"
Write-Host "Edit the <!-- description: ... --> lines to improve them, then run Update-GitHubDescriptions.ps1"
