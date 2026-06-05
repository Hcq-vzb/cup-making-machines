# Fill missing Arabic pages by copying from equivalent existing Arabic pages
# (Original ar.goldencupmachines.com does not host these URLs directly)
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$arRoot = Join-Path $root "ar"

# target path (under ar/) => source path (under ar/)
$mappings = [ordered]@{
    "products/paper-cup-machine.html"                          = "paper-cup-machine.html"
    "products/high-speed-paper-cup-machine.html"               = "high-speed-paper-cup-machine.html"
    "products/automatic-high-speed-paper-cup-machine.html"     = "high-speed-automatic-paper-cup-machine.html"
    "products/disposable-automatic-paper-cup-making-machine.html" = "disposable-automatic-cup-making-machine.html"
    "products/disposable-high-speed-paper-bowl-making-machine.html" = "disposable-high-speed-bowl-making-machine.html"
    "products/high-speed-disposable-paper-cup-machine.html"    = "high-speed-disposable-cup-machine.html"
    "products/ghigh-speed-paper-cup-machine.html"              = "high-speed-paper-cup-making-machine.html"
    "products/full-servo-paper-cup-sleeve-machine.html"        = "paper-cup-sleeve-machine.html"
    "products/salad-bowl-machine-square-paper-bowl-machine.html" = "xsl-2000s-xsl-2000f-salad-bowl-machine-square-paper-bowl-machine.html"
    "salad-bowl-machine.html"                                  = "high-speed-salad-bowl-machine.html"
    "double-wall-machine.html"                                 = "paper-cup-sleeve-machine.html"
    "automatic-double-wall-making-machine.html"                = "xsl16w-xsl-16sw-double-wallsleeve-machine-full-servo-paper-cup-sleeve-machine.html"
    "disposable-high-speed-double-wall-machine.html"           = "xsl16w-xsl-16sw-double-wallsleeve-machine-full-servo-paper-cup-sleeve-machine.html"
    "high-speed-automatic-double-wall-machine.html"            = "xsl16w-xsl-16sw-double-wallsleeve-machine-full-servo-paper-cup-sleeve-machine.html"
}

function Get-DirDepth {
    param([string]$RelPath)
    $dir = Split-Path $RelPath -Parent
    if ([string]::IsNullOrEmpty($dir)) { return 0 }
    return ($dir -replace '\\','/' -split '/').Count
}

function Adjust-PathsForDepth {
    param([string]$Content, [int]$DepthDelta)
    if ($DepthDelta -le 0) { return $Content }
    $up = "../" * $DepthDelta
    # Asset paths
    $Content = $Content -replace '(href|src)="\.\./Template/', "`$1=`"${up}../Template/"
    $Content = $Content -replace '(href|src)="\.\./upload/', "`$1=`"${up}../upload/"
    return $Content
}

$created = 0
foreach ($target in $mappings.Keys) {
    $source = $mappings[$target]
    $srcPath = Join-Path $arRoot $source
    $destPath = Join-Path $arRoot $target

    if (!(Test-Path $srcPath)) {
        Write-Host "SKIP (no source): $target <= $source"
        continue
    }
    if (Test-Path $destPath) {
        Write-Host "EXISTS: $target"
        continue
    }

    $srcDepth = Get-DirDepth $source
    $destDepth = Get-DirDepth $target
    $delta = $destDepth - $srcDepth

    $content = [System.IO.File]::ReadAllText($srcPath, [System.Text.Encoding]::UTF8)
    $content = Adjust-PathsForDepth -Content $content -DepthDelta $delta

    $destDir = Split-Path $destPath -Parent
    if ($destDir -and !(Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }

    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($destPath, $content, $utf8)
    Write-Host "CREATED: $target <= $source (depth +$delta)"
    $created++
}

Write-Host "Created $created missing Arabic pages"
