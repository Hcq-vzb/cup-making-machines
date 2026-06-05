# Download all upload assets referenced by the static site
$ErrorActionPreference = 'Continue'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
$bases = @(
    "https://www.goldencupmachines.com",
    "https://i.trade-cloud.com.cn",
    "https://ar.goldencupmachines.com"
)

$paths = [System.Collections.Generic.HashSet[string]]::new()
Get-ChildItem $root -Filter "*.html" -Recurse | Where-Object { $_.FullName -notlike "*\scripts\*" } | ForEach-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    [regex]::Matches($c, '(?:https?://(?:ar\.|www\.)?goldencupmachines\.com|https://i\.trade-cloud\.com\.cn)(/upload/[^"''\s>)]+)') | ForEach-Object {
        [void]$paths.Add($_.Groups[1].Value.TrimStart('/'))
    }
    [regex]::Matches($c, '(?:\.\./)*upload/([^"''\s>)]+)') | ForEach-Object {
        [void]$paths.Add("upload/$($_.Groups[1].Value -replace '\?.*$','')")
    }
}

Write-Host "Downloading $($paths.Count) upload files..."
$ok = 0; $fail = 0; $skip = 0
foreach ($rel in ($paths | Sort-Object)) {
    $local = Join-Path $root ($rel -replace '/','\')
    if (Test-Path $local) { $skip++; continue }
    $dir = Split-Path $local -Parent
    if ($dir -and !(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $downloaded = $false
    foreach ($base in $bases) {
        $url = "$base/$rel"
        try {
            Invoke-WebRequest -Uri $url -UserAgent $ua -UseBasicParsing -TimeoutSec 90 -OutFile $local
            if ((Get-Item $local).Length -gt 0) {
                Write-Host "OK $rel"
                $ok++; $downloaded = $true; break
            }
            Remove-Item $local -Force -ErrorAction SilentlyContinue
        } catch { }
    }
    if (-not $downloaded) { Write-Host "FAIL $rel"; $fail++ }
    Start-Sleep -Milliseconds 150
}
Write-Host "Done: $ok downloaded, $skip existed, $fail failed"
