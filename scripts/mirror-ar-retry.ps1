# Retry failed Arabic pages - try URL without .html extension
$ErrorActionPreference = 'Continue'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$arRoot = Join-Path $root "ar"
$baseUrl = "https://ar.goldencupmachines.com"
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"

function Download-Page {
    param([string[]]$Urls, [string]$LocalPath)
    $dir = Split-Path $LocalPath -Parent
    if ($dir -and !(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    foreach ($url in $Urls) {
        try {
            $response = Invoke-WebRequest -Uri $url -UserAgent $userAgent -UseBasicParsing -TimeoutSec 90
            [System.IO.File]::WriteAllText($LocalPath, $response.Content, [System.Text.Encoding]::UTF8)
            Write-Host "OK: $url"
            return $true
        } catch {
            Write-Host "TRY FAIL: $url"
        }
    }
    return $false
}

$failed = @(
    "automatic-double-wall-making-machine.html",
    "automatic-paper-bowl-machine.html",
    "automatic-paper-cup-machine.html",
    "automatic-salad-bowl-machine.html",
    "disposable-high-speed-double-wall-machine.html",
    "disposable-paper-bowl-machine.html",
    "disposable-paper-cup-machine.html",
    "disposable-salad-bowl-machine.html",
    "double-wall-machine.html",
    "high-speed-automatic-double-wall-machine.html",
    "high-speed-paper-bowl-machine.html",
    "high-speed-paper-cup-machine.html",
    "high-speed-salad-bowl-machine.html",
    "paper-bowl-machine.html",
    "paper-cup-machine.html",
    "paper-cup-packing-machine.html",
    "paper-cup-sleeve-machine.html",
    "salad-bowl-machine.html",
    "high-speed-paper-cup-machine/p2.html",
    "news/company-news.html",
    "news/industry-news.html",
    "news/industry-news/p2.html",
    "news/industry-news/p3.html",
    "news/industry-news/p4.html",
    "news/industry-news/p5.html",
    "news/industry-news/p6.html",
    "paper-bowl-machine/p2.html",
    "paper-cup-machine/p2.html",
    "paper-cup-machine/p3.html",
    "products/automatic-high-speed-paper-cup-machine.html",
    "products/disposable-automatic-paper-cup-making-machine.html",
    "products/disposable-high-speed-paper-bowl-making-machine.html",
    "products/full-servo-paper-cup-sleeve-machine.html",
    "products/ghigh-speed-paper-cup-machine.html",
    "products/high-speed-disposable-paper-cup-machine.html",
    "products/high-speed-paper-cup-machine.html",
    "products/paper-cup-machine.html",
    "products/salad-bowl-machine-square-paper-bowl-machine.html"
)

$ok = 0; $fail = 0
foreach ($rel in $failed) {
    $noExt = $rel -replace '\.html$', ''
    $urls = @(
        "$baseUrl/$noExt",
        "$baseUrl/$rel"
    )
    $localPath = Join-Path $arRoot $rel
    if (Download-Page -Urls $urls -LocalPath $localPath) { $ok++ } else { $fail++ }
    Start-Sleep -Milliseconds 300
}
Write-Host "Retry done: $ok ok, $fail fail"
