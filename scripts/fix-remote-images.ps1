# Fix malformed image paths and any remaining remote upload URLs
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"

function Get-UploadPrefix {
    param([string]$FilePath)
    $isArabic = $FilePath -like "*\ar\*"
    if ($isArabic) {
        $rel = $FilePath.Substring((Join-Path $root "ar").Length + 1)
        $dir = Split-Path $rel -Parent
        $depth = if ([string]::IsNullOrEmpty($dir)) { 0 } else { ($dir -replace '\\','/' -split '/').Count }
        return ("../" * ($depth + 1))
    }
    $rel = $FilePath.Substring($root.Length + 1)
    $dir = Split-Path $rel -Parent
    if ([string]::IsNullOrEmpty($dir)) { return "" }
    $depth = ($dir -replace '\\','/' -split '/').Count
    return ("../" * $depth)
}

$files = Get-ChildItem $root -Filter "*.html" -Recurse | Where-Object { $_.FullName -notlike "*\scripts\*" }
$fixed = 0
foreach ($f in $files) {
    $prefix = Get-UploadPrefix -FilePath $f.FullName
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $newContent = $content

    # Fix malformed paths from prior replace
    $newContent = $newContent -replace '(?:\.\./)+i\.trade-cloud\.com\.cn/upload/', "${prefix}upload/"
    $newContent = $newContent -replace '(?<![/\w])i\.trade-cloud\.com\.cn/upload/', "${prefix}upload/"

    # Remaining remote upload URLs
    $newContent = [regex]::Replace($newContent,
        'https?://(?:ar\.|www\.)?goldencupmachines\.com/upload/([^"''\s>)]+)',
        { param($m) "${prefix}upload/$($m.Groups[1].Value)" })
    $newContent = [regex]::Replace($newContent,
        'https://i\.trade-cloud\.com\.cn/upload/([^"''\s>)]+)',
        { param($m) "${prefix}upload/$($m.Groups[1].Value)" })

    if ($newContent -ne $content) {
        $utf8 = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($f.FullName, $newContent, $utf8)
        $fixed++
    }
}
Write-Host "Cleaned image paths in $fixed files"
