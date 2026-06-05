# Fix Arabic label encoding in language switcher
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$arLabel = [System.Text.RegularExpressions.Regex]::Unescape("\u0627\u0644\u0639\u0631\u0628\u064A\u0629")

$files = Get-ChildItem -Path $root -Filter "*.html" -Recurse |
    Where-Object { $_.FullName -notlike "*\scripts\*" }

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $newContent = [regex]::Replace($content,
        '(<li class="language-flag language-flag-ar"><a title=")[^"]*(" href="[^"]*" class="b"><b class="country-flag"></b><span>)[^<]*(</span></a></li>)',
        "`${1}$arLabel`${2}$arLabel`${3}")
    if ($newContent -ne $content) {
        $utf8 = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($f.FullName, $newContent, $utf8)
    }
}
Write-Host "Fixed Arabic label in $($files.Count) files"
