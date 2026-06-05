# Mirror Arabic pages from ar.goldencupmachines.com matching English site structure
$ErrorActionPreference = 'Continue'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$arRoot = Join-Path $root "ar"
$baseUrl = "https://ar.goldencupmachines.com"
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

function Download-Page {
    param([string]$RelativePath, [string]$LocalPath)
    $url = if ($RelativePath -eq "index.html") { "$baseUrl/" } else { "$baseUrl/$RelativePath" }
    $dir = Split-Path $LocalPath -Parent
    if ($dir -and !(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    try {
        $response = Invoke-WebRequest -Uri $url -UserAgent $userAgent -UseBasicParsing -TimeoutSec 60
        [System.IO.File]::WriteAllText($LocalPath, $response.Content, [System.Text.Encoding]::UTF8)
        return $true
    } catch {
        Write-Host "FAIL: $url - $($_.Exception.Message)"
        return $false
    }
}

# Get all HTML files from English site (excluding ar folder)
$htmlFiles = Get-ChildItem -Path $root -Filter "*.html" -Recurse |
    Where-Object { $_.FullName -notlike "*\ar\*" -and $_.FullName -notlike "*\scripts\*" }

$ok = 0; $fail = 0
foreach ($file in $htmlFiles) {
    $rel = $file.FullName.Substring($root.Length + 1).Replace('\', '/')
    $localPath = Join-Path $arRoot $rel
    if (Download-Page -RelativePath $rel -LocalPath $localPath) { $ok++ } else { $fail++ }
    Start-Sleep -Milliseconds 200
}

Write-Host "Done: $ok succeeded, $fail failed out of $($htmlFiles.Count) pages"
