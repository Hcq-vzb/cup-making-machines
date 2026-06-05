# Update navigation WhatsApp link with wa.me URL and verification message
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

$waPhone = '8617751189576'
$waSite = 'https://www.cupmakingmachines.com'

$textEn = "Hello! I found KIWL on $waSite and I'm interested in paper cup, paper bowl and salad bowl machines. Please verify my inquiry."
$textAr = [string]::Concat(
    [char]0x0645,[char]0x0631,[char]0x062D,[char]0x0628,[char]0x0627,[char]0x064B,[char]0x0021,[char]0x0020,
    [char]0x0648,[char]0x062C,[char]0x062F,[char]0x062A,[char]0x0020,[char]0x004B,[char]0x0049,[char]0x0057,[char]0x004C,[char]0x0020,
    [char]0x0639,[char]0x0628,[char]0x0631,[char]0x0020,[char]0x0020,$waSite,[char]0x0020,
    [char]0x0648,[char]0x0623,[char]0x0646,[char]0x0627,[char]0x0020,[char]0x0645,[char]0x0647,[char]0x062A,[char]0x0645,[char]0x0020,
    [char]0x0628,[char]0x0622,[char]0x0644,[char]0x0627,[char]0x062A,[char]0x0020,[char]0x0627,[char]0x0644,[char]0x0623,[char]0x0643,[char]0x0648,[char]0x0627,[char]0x0628,[char]0x0020,
    [char]0x0627,[char]0x0644,[char]0x0648,[char]0x0631,[char]0x0642,[char]0x064A,[char]0x0629,[char]0x0020,[char]0x0648,[char]0x0622,[char]0x0644,[char]0x0627,[char]0x062A,[char]0x0020,
    [char]0x0648,[char]0x0639,[char]0x0627,[char]0x0621,[char]0x0020,[char]0x0627,[char]0x0644,[char]0x0633,[char]0x0644,[char]0x0637,[char]0x0629,[char]0x002E,[char]0x0020,
    [char]0x064A,[char]0x0631,[char]0x062C,[char]0x0649,[char]0x0020,[char]0x0627,[char]0x0644,[char]0x062A,[char]0x062D,[char]0x0642,[char]0x0642,[char]0x0020,
    [char]0x0645,[char]0x0646,[char]0x0020,[char]0x0627,[char]0x0633,[char]0x062A,[char]0x0641,[char]0x0633,[char]0x0627,[char]0x0631,[char]0x064A,[char]0x002E
)

$urlEn = "https://wa.me/$waPhone" + '?text=' + [uri]::EscapeDataString($textEn)
$urlAr = "https://wa.me/$waPhone" + '?text=' + [uri]::EscapeDataString($textAr)

$updated = 0

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
    if ($content -notmatch 'class="call more_cont_1"') { return }

    $isAr = $_.FullName -like '*\ar\*'
    $newUrl = if ($isAr) { $urlAr } else { $urlEn }
    $orig = $content

    $content = [regex]::Replace(
        $content,
        '(<a class="call more_cont_1" target="_blank" href=")[^"]*(")',
        '${1}' + $newUrl + '${2}',
        $opts
    )

    if ($content -ne $orig) {
        [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        $updated++
    }
}

Write-Host "Done. Updated navigation WhatsApp on $updated file(s)."
Write-Host "EN: $urlEn"
Write-Host "AR: $urlAr"
