# Convert absolute root paths (/page) to relative paths in Arabic HTML files
# Fixes local file:// browsing where /message.html resolves to C:/message.html
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$arRoot = Join-Path $root "ar"

function Get-DepthPrefix {
    param([string]$RelFromAr)
    $dir = Split-Path $RelFromAr -Parent
    if ([string]::IsNullOrEmpty($dir)) { return "" }
    $depth = ($dir -replace '\\','/' -split '/').Count
    if ($depth -le 0) { return "" }
    return ("../" * $depth)
}

function Get-AssetPrefix {
    param([string]$RelFromAr)
    $dir = Split-Path $RelFromAr -Parent
    $depth = 0
    if (-not [string]::IsNullOrEmpty($dir)) {
        $depth = ($dir -replace '\\','/' -split '/').Count
    }
    return ("../" * ($depth + 1))
}

function Resolve-SitePath {
    param([string]$PathPart, [string]$SiteRoot)
    if ([string]::IsNullOrEmpty($PathPart)) { return "index.html" }

    $pathOnly = $PathPart
    $query = ""
    if ($PathPart -match '^([^?]+)(\?.*)$') {
        $pathOnly = $Matches[1]
        $query = $Matches[2]
    }

    # Extensionless page URL -> .html if file exists under ar/
    if ($pathOnly -notmatch '\.[a-zA-Z0-9]{2,5}$') {
        $localHtml = Join-Path $arRoot ($pathOnly -replace '/','\')
        $localHtml = "$localHtml.html"
        if (Test-Path $localHtml) {
            $pathOnly = "$pathOnly.html"
        }
    }

    return "$pathOnly$query"
}

function Fix-ProtocolRelativeLinks {
    param([string]$Content, [string]$PagePrefix)
    return [regex]::Replace($Content, 'href="//ar\.goldencupmachines\.com/([^"]*)"', {
        param($m)
        $pathPart = $m.Groups[1].Value
        $resolved = Resolve-SitePath -PathPart $pathPart -SiteRoot $root
        "href=`"${PagePrefix}${resolved}`""
    })
}

function Fix-AbsolutePaths {
    param([string]$Content, [string]$PagePrefix, [string]$AssetPrefix)
    return [regex]::Replace($Content, '(href|src|action)="/(?!/)([^"]*)"', {
        param($m)
        $attr = $m.Groups[1].Value
        $pathPart = $m.Groups[2].Value
        $resolved = Resolve-SitePath -PathPart $pathPart -SiteRoot $root
        $prefix = if ($resolved -match '^(css|js|upload)/') { $AssetPrefix } else { $PagePrefix }
        "${attr}=`"${prefix}${resolved}`""
    })
}

$files = Get-ChildItem -Path $arRoot -Filter "*.html" -Recurse
$fixed = 0
foreach ($f in $files) {
    $rel = $f.FullName.Substring($arRoot.Length + 1)
    $pagePrefix = Get-DepthPrefix -RelFromAr $rel
    $assetPrefix = Get-AssetPrefix -RelFromAr $rel
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $newContent = Fix-AbsolutePaths -Content $content -PagePrefix $pagePrefix -AssetPrefix $assetPrefix
    $newContent = Fix-ProtocolRelativeLinks -Content $newContent -PagePrefix $pagePrefix
    $newContent = $newContent -replace 'href="" title="teams"', 'href="#" title="teams"'
    if ($newContent -ne $content) {
        $utf8 = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($f.FullName, $newContent, $utf8)
        $fixed++
    }
}
Write-Host "Fixed absolute paths in $fixed / $($files.Count) Arabic HTML files"
