# Inject KIWL live chat widget site-wide (CSS + JS)
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"

function Get-AssetPrefix([string]$relativePath) {
    $dir = Split-Path $relativePath -Parent
    if ([string]::IsNullOrEmpty($dir)) { return '' }
    $depth = ($dir -split '[\\/]').Count
    return ('../' * $depth)
}

$updated = 0

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
    $relative = $_.FullName.Substring($root.Length + 1)
    $prefix = Get-AssetPrefix $relative
    $cssLink = "<link href=`"${prefix}Template/316/css/live-chat.css`" rel=`"stylesheet`" type=`"text/css`" />"
    $jsTag = "<script src=`"${prefix}Template/316/js/live-chat.js`"></script>"
    $snippet = "$cssLink`r`n$jsTag`r`n"
    $changed = $false

    if ($content -match 'live-chat\.js') {
        if ($content -notmatch 'live-chat\.css') {
            $content = $content -replace '(<script src="(?:\.\./)*Template/316/js/live-chat\.js"></script>)', ($cssLink + "`r`n`$1")
            $changed = $true
        }
    } elseif ($content -match '</body>') {
        $content = $content -replace '</body>', ($snippet + '</body>')
        $changed = $true
    } else {
        Write-Warning "Skip (no </body>): $relative"
        return
    }

    if ($changed) {
        [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        $updated++
    }
}

Write-Host "Done. Updated $updated file(s)."
