# Update ALL WhatsApp links site-wide with wa.me/8617751189576 + page URL & product verification
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$baseUrl = 'https://www.cupmakingmachines.com'
$waPhone = '8617751189576'
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

function Get-PageUrl([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/')
    if ($p -eq 'index.html') { return "$baseUrl/" }
    if ($p -eq 'ar/index.html') { return "$baseUrl/ar/" }
    return "$baseUrl/$p"
}

function Get-ProductLabel([string]$content) {
    if ($content -notmatch '<title>([^<]+)</title>') { return 'KIWL Machinery' }
    $t = $Matches[1]
    $t = $t -replace '\s*[-|]\s*KIWL.*$', ''
    $t = $t -replace '\s*[-|]\s*Jiangsu.*$', ''
    $t = $t -replace '\s*[-|]\s*Page \d+.*$', ''
    $t = $t -replace '\s*\|\s*KIWL.*$', ''
    $t = $t.Trim()
    if ($t.Length -gt 120) { $t = $t.Substring(0, 120).Trim() }
    if ([string]::IsNullOrWhiteSpace($t)) { return 'KIWL Machinery' }
    return $t
}

function Get-ArWaMessage([string]$pageUrl, [string]$product) {
    $parts = @(
        0x0645,0x0631,0x062D,0x0628,0x0627,0x064B,0x0021,0x0020,
        0x0648,0x062C,0x062F,0x062A,0x0020,0x004B,0x0049,0x0057,0x004C,0x0020,
        0x0639,0x0628,0x0631,0x0020
    )
    $mid = @(
        0x0020,0x0648,0x0623,0x0646,0x0627,0x0020,0x0645,0x0647,0x062A,0x0645,0x0020,
        0x0628,0x0640,0x003A,0x0020
    )
    $suffix = @(
        0x002E,0x0020,0x064A,0x0631,0x062C,0x0649,0x0020,0x0627,0x0644,0x062A,0x062D,0x0642,0x0642,0x0020,
        0x0645,0x0646,0x0020,0x0627,0x0633,0x062A,0x0641,0x0633,0x0627,0x0631,0x064A,0x002E
    )
    $prefix = -join ($parts | ForEach-Object { [char]$_ })
    $midStr = -join ($mid | ForEach-Object { [char]$_ })
    $suffixStr = -join ($suffix | ForEach-Object { [char]$_ })
    return $prefix + $pageUrl + $midStr + $product + $suffixStr
}

function Get-WaMessage([string]$pageUrl, [string]$product, [bool]$isAr) {
    if ($isAr) {
        return Get-ArWaMessage $pageUrl $product
    }
    $msg = "Hello! I found KIWL on $pageUrl and I'm interested in: $product. Please verify my inquiry."
    return $msg
}

function Get-WaUrl([string]$pageUrl, [string]$product, [bool]$isAr) {
    $text = Get-WaMessage $pageUrl $product $isAr
    return "https://wa.me/$waPhone" + '?text=' + [uri]::EscapeDataString($text)
}

$waPattern = 'href="https://(?:api\.whatsapp\.com/send\?phone=\d+(?:&amp;|&)text=[^"]*|wa\.me/\d+\?text=[^"]*)"'

$updated = 0
$linkCount = 0

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
    if ($content -notmatch 'whatsapp|wa\.me|api\.whatsapp') { return }

    $relative = $_.FullName.Substring($root.Length + 1)
    $isAr = $relative -like 'ar\*'
    $pageUrl = Get-PageUrl $relative
    $product = Get-ProductLabel $content
    $waUrl = Get-WaUrl $pageUrl $product $isAr
    $orig = $content

    $matches = [regex]::Matches($content, $waPattern)
    if ($matches.Count -eq 0) { return }

    $content = [regex]::Replace($content, $waPattern, "href=`"$waUrl`"", $opts)

    if ($content -ne $orig) {
        [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        $updated++
        $linkCount += $matches.Count
    }
}

Write-Host "Done. Updated $updated file(s), $linkCount WhatsApp link(s)."
Write-Host "Example EN: $(Get-WaUrl (Get-PageUrl 'xsl-350t-high-speed-paper-cup-machine.html') (Get-ProductLabel ([IO.File]::ReadAllText((Join-Path $root 'xsl-350t-high-speed-paper-cup-machine.html'), [Text.UTF8Encoding]::new($false)))) $false)"
