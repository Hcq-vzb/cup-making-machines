# Replace address, phone, and email site-wide
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"

$replacements = @(
    @{ Old = '8613738752307'; New = '8618151132311' },
    @{ Old = '+86-13738752307'; New = '+86-18151132311' },
    @{ Old = '13738752307'; New = '18151132311' },
    @{ Old = 'info@goldencup-machine.com'; New = 'cathy@cupmakingmachines.com' },
    @{ Old = 'NO.399, Jiangnan Avenu, Gexiang New District, Ruian City, Wenzhou City, Zhejiang Province, China'; New = 'Building 4, Xingyuan Road, Nanfeng Town, Zhangjiagang City, Jiangsu Province, China' },
    @{ Old = 'is located in Ruian City, Wenzhou City, Zhejiang Province, China'; New = 'is located in Zhangjiagang City, Jiangsu Province, China' },
    @{ Old = 'Ruian City, Wenzhou City, Zhejiang Province'; New = 'Zhangjiagang City, Jiangsu Province' }
)

# Arabic replacements (UTF-8)
$replacements += @(
    @{ Old = 'رقم 399، شارع جيانغنان، منطقة جيكسيانج الجديدة، مدينة رويان، مدينة ونتشو، مقاطعة تشجيانغ، الصين'; New = 'مبنى 4، طريق Xingyuan، بلدة Nanfeng، مدينة Zhangjiagang، مقاطعة Jiangsu، الصين' },
    @{ Old = 'في مدينة Ruian، مدينة Wenzhou، مقاطعة Zhejiang، الصين'; New = 'في مدينة Zhangjiagang، مقاطعة Jiangsu، الصين' }
)

$updated = 0
$total = 0

Get-ChildItem $root -Include *.html,*.xml -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
    $orig = $content
    $fc = 0
    foreach ($p in $replacements) {
        $n = ([regex]::Matches($content, [regex]::Escape($p.Old))).Count
        if ($n -gt 0) {
            $content = $content.Replace($p.Old, $p.New)
            $fc += $n
        }
    }
    if ($content -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $content, [Text.UTF8Encoding]::new($false))
        $updated++
        $total += $fc
    }
}

Write-Host "Done: $updated files, $total replacements"
