# Fix empty img src for news articles missing CMS thumbnails (Arabic pages)
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"

$thumbnails = @{
    'how-long-does-it-take-to-turn-a-piece-of-paper-into-a-formed-paper-cup.html' = 'high-speed-paper-cup-making-machine_97103.jpg'
    'definition-and-characteristics-of-paper-cup-machine.html' = '20251017160653250461.jpg'
}

$fixed = 0
Get-ChildItem (Join-Path $root 'ar') -Filter '*.html' -Recurse | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    if ($content -notmatch '<img src=""') { return }

    $prefixMatch = [regex]::Match($content, 'src="((?:\.\./)+)upload/7728/')
    if (-not $prefixMatch.Success) {
        Write-Warning "No upload prefix in $($_.FullName)"
        return
    }
    $prefix = $prefixMatch.Groups[1].Value

    $original = $content
    foreach ($slug in $thumbnails.Keys) {
        $image = $thumbnails[$slug]
        $pattern = '(<a href="(?:\.\./)*news/' + [regex]::Escape($slug) + '"[^>]*class="thumb[^"]*"[^>]*><img src=")(?:#|")'
        $replacement = '${1}' + $prefix + 'upload/7728/' + $image + '"'
        $content = [regex]::Replace($content, $pattern, $replacement)
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        $fixed++
        Write-Host "Fixed $($_.FullName.Substring($root.Length + 1))"
    }
}

Write-Host "Done: $fixed Arabic files updated"
