# SEO follow-up: sitemap with Arabic, 404 redirects, merge Google Analytics
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$baseUrl = 'https://www.cupmakingmachines.com'
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

$redirectPages = @{
    'salad-bowl-machine.html' = 'high-speed-salad-bowl-machine.html'
    'double-wall-machine.html' = 'paper-cup-sleeve-machine.html'
    'high-speed-automatic-double-wall-machine.html' = 'paper-cup-sleeve-machine.html'
    'disposable-high-speed-double-wall-machine.html' = 'paper-cup-sleeve-machine.html'
    'automatic-double-wall-making-machine.html' = 'xsl16w-xsl-16sw-double-wallsleeve-machine-full-servo-paper-cup-sleeve-machine.html'
    'news\www.goldencupmachines.html' = 'index.html'
    'ar\news\www.goldencupmachines.html' = 'ar/index.html'
}

$sitemapExclude = @(
    'thank.html', 'ar\thank.html',
    'news\www.goldencupmachines.html', 'ar\news\www.goldencupmachines.html'
) + @($redirectPages.Keys | Where-Object { $_ -notlike 'news\*' -and $_ -notlike 'ar\*' })

function New-RedirectHtml([string]$targetPath, [string]$lang) {
    $p = $targetPath -replace '\\', '/'
    $targetUrl = if ($p -eq 'index.html') { "$baseUrl/" }
                 elseif ($p -eq 'ar/index.html') { "$baseUrl/ar/" }
                 else { "$baseUrl/$p" }
    $isAr = $lang -eq 'ar'
    $title = if ($isAr) { 'جاري التحويل...' } else { 'Redirecting...' }
    $text = if ($isAr) { 'انقر هنا للمتابعة' } else { 'Click here to continue' }
    return @"
<!DOCTYPE html>
<html lang="$lang">
<head>
<meta charset="UTF-8">
<meta http-equiv="refresh" content="0; url=$targetUrl">
<meta name="robots" content="noindex, follow">
<link rel="canonical" href="$targetUrl">
<title>$title</title>
<script>location.replace('$targetUrl');</script>
</head>
<body><p><a href="$targetUrl">$text</a></p></body>
</html>
"@
}

# --- 404 pages -> redirects ---
$redirectCount = 0
foreach ($entry in $redirectPages.GetEnumerator()) {
    $filePath = Join-Path $root $entry.Key
    if (-not (Test-Path $filePath)) { continue }
    $lang = if ($entry.Key -like 'ar\*') { 'ar' } else { 'en' }
    $target = $entry.Value
    $html = New-RedirectHtml $target $lang
    [System.IO.File]::WriteAllText($filePath, $html, [System.Text.UTF8Encoding]::new($false))
    $redirectCount++
}

# --- Merge Google Analytics (remove duplicate G-J4C10W51ZB block) ---
$gaRemoved = 0
$duplicateGaPattern = '\r?\n<!-- Google tag \(gtag\.js\) -->\r?\n<script async src="https://www\.googletagmanager\.com/gtag/js\?id=G-J4C10W51ZB"></script>\r?\n<script>\r?\n  window\.dataLayer = window\.dataLayer \|\| \[\];\r?\n  function gtag\(\)\{dataLayer\.push\(arguments\);\}\r?\n  gtag\(''js'', new Date\(\)\);\r?\n\r?\n  gtag\(''config'', ''G-J4C10W51ZB''\);\r?\n</script>'

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
    if ($content -notmatch 'G-J4C10W51ZB') { return }
    $newContent = [regex]::Replace($content, $duplicateGaPattern, '', $opts)
    if ($newContent -ne $content) {
        [System.IO.File]::WriteAllText($_.FullName, $newContent, [System.Text.UTF8Encoding]::new($false))
        $script:gaRemoved++
    }
}

# --- Regenerate sitemap.xml (EN + AR) ---
function Get-SitemapPriority([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/').ToLower()
    if ($p -eq 'index.html' -or $p -eq 'ar/index.html') { return '1.0' }
    if ($p -match '^(ar/)?(about|products|contact|paper-cup-machine|paper-bowl-machine|news)\.html$') { return '0.9' }
    if ($p -match '/news/') { return '0.7' }
    return '0.8'
}

$urlEntries = New-Object System.Collections.Generic.List[string]
$now = (Get-Date).ToString('yyyy-MM-dd')

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $rel = $_.FullName.Substring($root.Length + 1)
    $rel -notin $sitemapExclude -and $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1) -replace '\\', '/'
    $lastmod = $_.LastWriteTime.ToString("yyyy-MM-dd'T'HH:mm:ss+08:00")
    $loc = if ($rel -eq 'index.html') { "$baseUrl/" }
           elseif ($rel -eq 'ar/index.html') { "$baseUrl/ar/" }
           else { "$baseUrl/$rel" }
    $priority = Get-SitemapPriority $rel
    $urlEntries.Add("<url><lastmod>$lastmod</lastmod><changefreq>weekly</changefreq><priority>$priority</priority><loc>$loc</loc></url>")
}

$sorted = $urlEntries | Sort-Object { if ($_ -match '<loc>([^<]+)</loc>') { $Matches[1] } else { $_ } }
$xml = '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="' + $baseUrl + '/sitemap.xslt"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + ($sorted -join '') + '</urlset>'
[System.IO.File]::WriteAllText((Join-Path $root 'sitemap.xml'), $xml, [System.Text.UTF8Encoding]::new($false))

$arCount = ($sorted | Where-Object { $_ -match '/ar/' }).Count
$enCount = $sorted.Count - $arCount

Write-Host "Done."
Write-Host "  404 redirects: $redirectCount"
Write-Host "  GA merged: $gaRemoved files"
Write-Host "  Sitemap URLs: $($sorted.Count) (EN: $enCount, AR: $arCount)"
