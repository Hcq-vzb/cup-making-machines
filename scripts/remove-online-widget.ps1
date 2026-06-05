# Remove floating #online sidebar (WhatsApp + E-Mail) site-wide
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

$updated = 0

function Remove-OnlineWidget([string]$content) {
    $original = $content

    $content = [regex]::Replace(
        $content,
        '<link href="(?:\.\./)*onlineservice/01/css/online\.css" rel="stylesheet" type="text/css"\s*/>\s*',
        '',
        $opts
    )

    $content = [regex]::Replace(
        $content,
        '<div id="online">\s*<ul class="online-list">.*?</ul>\s*</div>\s*',
        '',
        $opts
    )

    if ($content -ne $original) { return $content }
    return $null
}

Get-ChildItem -Path $root -Filter '*.html' -Recurse | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName)
    $newContent = Remove-OnlineWidget $content
    if ($null -ne $newContent) {
        [System.IO.File]::WriteAllText($_.FullName, $newContent, [System.Text.UTF8Encoding]::new($false))
        $updated++
        Write-Host "Updated: $($_.FullName.Substring($root.Length + 1))"
    }
}

Write-Host "`nDone. Updated $updated file(s)."
