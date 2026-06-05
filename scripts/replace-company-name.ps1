# Replace company name site-wide
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"

$newEn = 'Jiangsu KIWL Machinery Manufacturing Group Co., Ltd'
$newAr = 'شركة Jiangsu KIWL Machinery Manufacturing Group Co., Ltd'
$newArShort = 'شركة مجموعة Jiangsu KIWL لتصنيع الآلات المحدودة'

$replacements = @(
    @{ Old = 'Zhejiang Golden Cup Machinery Co., Ltd.'; New = $newEn },
    @{ Old = 'Zhejiang Golden Cup Machinery Co.,Ltd.'; New = $newEn },
    @{ Old = 'Zhejiang Golden Cup Machinery Co., Ltd'; New = $newEn },
    @{ Old = 'Zhejiang Golden Cup Machinery Co.,Ltd'; New = $newEn },
    @{ Old = 'شركة Zhejiang Golden Cup Machinery Co., Ltd.'; New = $newAr },
    @{ Old = 'شركة Zhejiang Golden Cup Machinery Co., Ltd'; New = $newAr },
    @{ Old = 'شركة تشجيانغ للكأس الذهبية المحدودة'; New = $newArShort },
    @{ Old = 'Golden Cup Machinery'; New = 'KIWL Machinery' },
    @{ Old = 'Zhejiang Golden'; New = 'Jiangsu KIWL' },
    @{ Old = ', Golden focuses'; New = ', KIWL focuses' }
)

$extensions = @('*.html', '*.xml')
$updated = 0
$totalReplacements = 0

Get-ChildItem $root -Include $extensions -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*' -and $_.FullName -notlike '*\node_modules\*'
} | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    $fileCount = 0

    foreach ($pair in $replacements) {
        $count = ([regex]::Matches($content, [regex]::Escape($pair.Old))).Count
        if ($count -gt 0) {
            $content = $content.Replace($pair.Old, $pair.New)
            $fileCount += $count
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        $updated++
        $totalReplacements += $fileCount
        Write-Host "Updated $($_.FullName.Substring($root.Length + 1)) ($fileCount replacements)"
    }
}

Write-Host "Done: $updated files, $totalReplacements total replacements"
