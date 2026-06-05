# SEO optimization for www.cupmakingmachines.com launch
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$baseUrl = 'https://www.cupmakingmachines.com'
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

function Get-CanonicalUrl([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/').ToLower()
    if ($p -eq 'index.html') { return "$baseUrl/" }
    if ($p -eq 'ar/index.html') { return "$baseUrl/ar/" }
    return "$baseUrl/$p"
}

function Get-EnArPaths([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/')
    $isAr = $p -like 'ar/*' -or $p -eq 'ar\index.html'
    if ($isAr) {
        $enRel = if ($p -eq 'ar/index.html') { 'index.html' } else { ($p -replace '^ar/', '') }
        $arRel = $p
    } else {
        $enRel = $p
        $arRel = if ($p -eq 'index.html') { 'ar/index.html' } else { "ar/$p" }
    }
    return @{
        En = Get-CanonicalUrl $enRel
        Ar = Get-CanonicalUrl $arRel
        Self = Get-CanonicalUrl $p
        IsAr = $isAr
    }
}

function Add-KiwlKeywords([string]$content) {
    return [regex]::Replace($content, '(<meta name="keywords" content=")([^"]*)(")', {
        param($m)
        $kw = $m.Groups[2].Value
        if ($kw -match 'KIWL') { return $m.Value }
        return $m.Groups[1].Value + $kw + ', KIWL, KIWL Machinery, KIWL paper cup machine' + $m.Groups[3].Value
    })
}

function Add-KiwlTitle([string]$content) {
    if ($content -notmatch '<title>([^<]+)</title>') { return $content }
    $title = $Matches[1]
    if ($title -match 'KIWL|404 Not Found|Redirecting') { return $content }
    return $content -replace [regex]::Escape("<title>$title</title>"), "<title>$title | KIWL</title>"
}

$domainReplacements = @(
    @{ Old = 'https://ar.goldencupmachines.com'; New = 'https://www.cupmakingmachines.com/ar' },
    @{ Old = 'http://ar.goldencupmachines.com'; New = 'https://www.cupmakingmachines.com/ar' },
    @{ Old = 'https://www.goldencupmachines.com'; New = $baseUrl },
    @{ Old = 'http://www.goldencupmachines.com'; New = $baseUrl },
    @{ Old = '//www.goldencupmachines.com'; New = '//www.cupmakingmachines.com' }
)

$htmlUpdated = 0

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $relative = $_.FullName.Substring($root.Length + 1)
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
    $orig = $content

    # Remove HTTrack mirror artifacts
    $content = [regex]::Replace($content, '\r?\n<!-- Mirrored from www\.goldencupmachines\.com[^>]*-->\r?\n', "`r`n", $opts)
    $content = [regex]::Replace($content, '<!-- Added by HTTrack --><meta http-equiv="content-type" content="text/html;charset=utf-8" /><!-- /Added by HTTrack -->', '', $opts)
    $content = [regex]::Replace($content, '\r?\n<!-- Mirrored from www\.goldencupmachines\.com[^>]*-->\r?\n(?=</html>)', "`r`n", $opts)

    foreach ($r in $domainReplacements) {
        $content = $content.Replace($r.Old, $r.New)
    }

    # Fix outdated about meta (Zhejiang -> Zhangjiagang)
    $content = $content.Replace(
        'is situated in the Chinese province of Zhejiang, in the cities of Ruian and Wenzhou',
        'is located in Zhangjiagang City, Jiangsu Province, China'
    )

    $paths = Get-EnArPaths $relative

    # Absolute canonical
    $content = [regex]::Replace(
        $content,
        '<link href="[^"]*" rel="canonical"\s*/?>',
        "<link href=`"$($paths.Self)`" rel=`"canonical`" />",
        1
    )

    # Absolute hreflang
    if ($content -match 'hreflang="en"') {
        $content = [regex]::Replace($content, '<link rel="alternate" hreflang="en" href="[^"]*"/>', "<link rel=`"alternate`" hreflang=`"en`" href=`"$($paths.En)`"/>")
        $content = [regex]::Replace($content, '<link rel="alternate" hreflang="ar" href="[^"]*"/>', "<link rel=`"alternate`" hreflang=`"ar`" href=`"$($paths.Ar)`"/>")
        $content = [regex]::Replace($content, '<link rel="alternate" hreflang="x-default" href="[^"]*"/>', "<link rel=`"alternate`" hreflang=`"x-default`" href=`"$($paths.En)`"/>")
    }

    # KIWL in keywords and title
    $content = Add-KiwlKeywords $content
    $content = Add-KiwlTitle $content

    # Homepage meta boost
    if ($relative -eq 'index.html') {
        $content = $content -replace '(<meta name="keywords" content=")[^"]*(")', '${1}KIWL, KIWL Machinery, Paper Cup Machine, Paper Bowl Machine, Salad Bowl Machine, cupmakingmachines.com${2}'
        $content = $content -replace '(<meta name="description" content=")[^"]*(")', '${1}KIWL (Jiangsu KIWL Machinery) is a leading China manufacturer of paper cup machines, paper bowl machines and salad bowl machines. Visit www.cupmakingmachines.com for factory-direct pricing, ISO9001 & CE certified equipment.${2}'
    }

    if ($content -ne $orig) {
        [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        $htmlUpdated++
    }
}

# sitemap.xml & rss.xml
foreach ($xmlFile in @('sitemap.xml', 'rss.xml')) {
    $xmlPath = Join-Path $root $xmlFile
    if (-not (Test-Path $xmlPath)) { continue }
    $xml = [System.IO.File]::ReadAllText($xmlPath, [System.Text.UTF8Encoding]::new($false))
    $xml = $xml.Replace('https://www.goldencupmachines.com', $baseUrl)
    # Fix category URLs missing .html in sitemap
    $xml = [regex]::Replace($xml, '(<loc>https://www\.cupmakingmachines\.com/([a-z0-9\-/]+))</loc>', {
        param($m)
        $url = $m.Groups[1].Value
        if ($url -match '\.html$' -or $url -match '/$') { return $m.Value }
        return "$url.html</loc>"
    })
    [System.IO.File]::WriteAllText($xmlPath, $xml, [System.Text.UTF8Encoding]::new($false))
}

# live-chat.js domain
$chatJs = Join-Path $root 'Template\316\js\live-chat.js'
if (Test-Path $chatJs) {
    $js = [System.IO.File]::ReadAllText($chatJs, [System.Text.UTF8Encoding]::new($false))
    $js = $js.Replace('https://www.goldencupmachines.com', $baseUrl)
    $js = $js.Replace('goldencupmachines.com', 'cupmakingmachines.com')
    [System.IO.File]::WriteAllText($chatJs, $js, [System.Text.UTF8Encoding]::new($false))
}

# robots.txt
$robots = @"
User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml
"@
[System.IO.File]::WriteAllText((Join-Path $root 'robots.txt'), $robots, [System.Text.UTF8Encoding]::new($false))

Write-Host "Done. Updated $htmlUpdated HTML file(s)."
Write-Host "Created/updated robots.txt, sitemap.xml, rss.xml, live-chat.js"
