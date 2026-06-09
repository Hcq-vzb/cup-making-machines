# Full-site SEO pyramid keywords + Google compliance fixes for cupmakingmachines.com
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$baseUrl = 'https://www.cupmakingmachines.com'
$brandName = 'Jiangsu KIWL Machinery Manufacturing Group Co., Ltd'
$brandKw = 'KIWL, KIWL Machinery, cupmakingmachines.com'
$headKw = 'Paper Cup Machine, Paper Bowl Machine, Salad Bowl Machine'
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

function Get-CanonicalUrl([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/').ToLower()
    if ($p -eq 'index.html') { return "$baseUrl/" }
    if ($p -eq 'ar/index.html') { return "$baseUrl/ar/" }
    return "$baseUrl/$p"
}

function Get-SlugKeyword([string]$relativePath) {
    $name = [IO.Path]::GetFileNameWithoutExtension(($relativePath -replace '\\', '/'))
    if ($name -match '^p\d+$') { return $null }
    if ($name -eq 'index') { return $null }
    $map = @{
        'ghigh-speed-paper-cup-machine' = 'High Speed Paper Cup Machine'
        'xsl-16ts-xsl-320tpaper-cup-machine' = 'XSL-16TS XSL-320T Paper Cup Machine'
        'xsl-16t-xsl-16tghigh-speed-paper-cup-machine' = 'XSL-16T High Speed Paper Cup Machine'
        'xsl-350t-high-speed-paper-cup-machine' = 'XSL-350T High Speed Paper Cup Machine'
        'xsl16w-xsl-16sw-double-wallsleeve-machine-full-servo-paper-cup-sleeve-machine' = 'XSL-16W Double Wall Sleeve Machine'
        'xsl-2000s-xsl-2000f-salad-bowl-machine-square-paper-bowl-machine' = 'XSL-2000S Square Paper Bowl Machine'
    }
    if ($map.ContainsKey($name)) { return $map[$name] }
    return (Get-Culture).TextInfo.ToTitleCase(($name -replace '-', ' '))
}

function Get-ParentCategory([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/').ToLower()
    if ($p -match 'sleeve|double-wall|doublewall') { return 'Paper Cup Sleeve Machine' }
    if ($p -match 'packing|pack') { return 'Paper Cup Packing Machine' }
    if ($p -match 'salad-bowl|salad_bowl') { return 'Salad Bowl Machine' }
    if ($p -match 'paper-bowl|paper_bowl|bowl-making|bowl-machine|bowl-forming') { return 'Paper Bowl Machine' }
    if ($p -match 'paper-cup|paper_cup|cup-making|cup-machine|coffee-cup|disposable-cup') { return 'Paper Cup Machine' }
    if ($p -match 'news') { return 'Paper Cup Machine Industry' }
    return 'Paper Cup Machine'
}

function Get-PageTier([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/').ToLower()
    if ($p -eq 'index.html' -or $p -eq 'ar/index.html') { return 1 }
    if ($p -match '^(ar/)?(about|products|contact)\.html$') { return 1 }
    if ($p -match '^(ar/)?(paper-cup-machine|paper-bowl-machine|salad-bowl-machine|paper-cup-sleeve-machine|paper-cup-packing-machine)\.html$') { return 2 }
    if ($p -match '(^|/)news/') { return 5 }
    if ($p -match '/products/' -or $p -match '^products-' -or $p -match '^(ar/)?xsl' -or $p -match 'double-wallsleeve') { return 4 }
    if ($p -match '^(ar/)?(high-speed-|automatic-|disposable-|full-automatic-)') { return 3 }
    if ($p -match '^(ar/)?(news|download|message|links|privacy-policy|sitemap)\.html$') { return 1 }
    return 3
}

function Get-PyramidKeywords([string]$relativePath, [string]$title) {
    $tier = Get-PageTier $relativePath
    $primary = Get-SlugKeyword $relativePath
    if (-not $primary -and $title) {
        if ($title -match '^About Us') { $primary = 'About KIWL Machinery' }
        elseif ($title -match '^Products') { $primary = 'Paper Cup Making Machines' }
        elseif ($title -match '^Contact') { $primary = 'Contact KIWL' }
        elseif ($title -match '^News') { $primary = 'Paper Cup Machine News' }
        elseif ($title -match '^Download') { $primary = 'Paper Cup Machine Catalog' }
        elseif ($title -match '^Send Inquiry') { $primary = 'Paper Cup Machine Inquiry' }
        elseif ($title -match '^Privacy') { $primary = 'Privacy Policy' }
        elseif ($title -match '^Sitemap') { $primary = 'Sitemap' }
        elseif ($title -match '^Links') { $primary = 'Useful Links' }
        elseif ($title -match '^Industry News') { $primary = 'Paper Cup Machine Industry News' }
        elseif ($title -match '^Company News') { $primary = 'KIWL Company News' }
        else {
            $primary = ($title -split ' - ')[0].Trim()
            if ($primary.Length -gt 80) { $primary = $primary.Substring(0, 80).Trim() }
        }
    }
    if (-not $primary) { $primary = 'Paper Cup Machine' }
    $parent = Get-ParentCategory $relativePath

    switch ($tier) {
        1 {
            return "$headKw, China paper cup machine manufacturer, paper cup making machine factory, $brandKw"
        }
        2 {
            return "$primary, $headKw, China $primary manufacturer, supplier, factory, $brandKw"
        }
        3 {
            return "$primary, $parent, $headKw, China manufacturer, wholesale, $brandKw"
        }
        4 {
            return "$primary, $parent, China manufacturer, factory direct price, wholesale, $brandKw"
        }
        5 {
            return "$primary, paper cup machine, paper bowl machine, $parent, $brandKw"
        }
        default {
            return "$primary, $parent, $brandKw"
        }
    }
}

function Get-PyramidDescription([string]$relativePath, [string]$primary, [string]$existing) {
    $tier = Get-PageTier $relativePath
    $parent = Get-ParentCategory $relativePath
    $p = ($relativePath -replace '\\', '/').ToLower()
    $existing = $existing -replace '\\', ''

    if ($tier -eq 1 -and ($p -eq 'index.html' -or $p -eq 'ar/index.html')) {
        return "KIWL (Jiangsu KIWL Machinery) is a leading China manufacturer of paper cup machines, paper bowl machines and salad bowl machines. ISO9001 & CE certified. Factory-direct pricing at www.cupmakingmachines.com."
    }
    if ($p -match '^(ar/)?about\.html$') {
        return "Learn about KIWL Machinery in Zhangjiagang, Jiangsu — 10+ years manufacturing paper cup machines, paper bowl machines, salad bowl machines and double-wall sleeve equipment for global buyers."
    }
    if ($p -match '^(ar/)?products\.html$') {
        return "Browse KIWL paper cup machines, paper bowl machines, salad bowl machines, sleeve machines and packing equipment. Full servo, high-speed and automatic models with factory-direct support."
    }
    if ($p -match '^(ar/)?contact\.html$') {
        return "Contact KIWL Machinery for paper cup machine quotes, factory visits and technical support. WhatsApp +86-18151132311. Zhangjiagang, Jiangsu, China."
    }
    if ($existing -match 'KIWL Factory is your go-to factory for customized' -or
        $existing -match 'KIWL Factory has established itself as a leading' -or
        $existing -match 'KIWL offers .+ as a China manufacturer and supplier') {
        return "KIWL offers $primary as a China manufacturer and supplier. CE & ISO9001 certified, full servo options, factory-direct pricing. Request a quote for $parent production lines."
    }
    if ($existing -match '^Jiangsu KIWL Machinery Manufacturing Group Co., Ltd:' -and $existing.Length -lt 120) {
        return "Read KIWL expert insights on $primary - practical guidance on paper cup and paper bowl machine selection, operation and industry trends."
    }
    if ($existing -match 'Read KIWL expert insights on') {
        return $existing
    }
    if ($tier -eq 2) {
        return "Explore KIWL $primary models — high-speed, automatic and disposable options for food packaging factories. China manufacturer with CE certification and global export support."
    }
    if ($tier -ge 3 -and $existing.Length -lt 80) {
        return "KIWL $primary — reliable $parent solution from a China factory. Customizable specs, competitive wholesale pricing. Contact KIWL for specifications and delivery."
    }
    return $existing
}

function Set-MetaTag([string]$content, [string]$name, [string]$value) {
    $pattern = "(<meta name=`"$name`" content=`")[^`"]*(`")"
    if ($content -match $pattern) {
        $safe = $value -replace '&', '&amp;' -replace '"', '&quot;'
        return [regex]::Replace($content, $pattern, {
            param($m)
            return $m.Groups[1].Value + $safe + $m.Groups[2].Value
        }, 1)
    }
    return $content
}

function Set-OgMeta([string]$content, [string]$property, [string]$value) {
    $pattern = "(<meta property=`"$property`" content=`")[^`"]*(`")"
    if ($content -match $pattern) {
        return [regex]::Replace($content, $pattern, "`${1}$value`${2}", 1)
    }
    return $content
}

function Fix-AbsoluteImageUrls([string]$content, [string]$relativePath) {
    $depth = ([regex]::Matches($relativePath, '[\\/]')).Count
    $prefix = if ($depth -gt 0) { '../' * $depth } else { '' }

    $content = [regex]::Replace($content, '(property="og:image" content=")(?!https?://)([^"]+)(")', {
        param($m)
        $img = $m.Groups[2].Value
        if ($img.StartsWith('/')) { $abs = "$baseUrl$img" }
        elseif ($img.StartsWith('http')) { return $m.Value }
        else { $abs = "$baseUrl/$($img -replace '^\.\./','' -replace '^/','')" }
        return $m.Groups[1].Value + $abs + $m.Groups[3].Value
    })

    $content = [regex]::Replace($content, '("logo"\s*:\s*")(?!https?://)(upload/[^"]+)(")', "`${1}$baseUrl/`${2}`${3}")
    $content = [regex]::Replace($content, '("image"\s*:\s*")(?!https?://|/)(upload/[^"]+)(")', "`${1}$baseUrl/`${2}`${3}")
    $content = [regex]::Replace($content, '("url"\s*:\s*")(?!https?://)(/upload/[^"]+)(")', "`${1}$baseUrl`${2}`${3}")

    return $content
}

function Fix-SchemaUrls([string]$content) {
    # Breadcrumb / schema item URLs missing .html extension
    $content = [regex]::Replace($content,
        '("item"\s*:\s*"https://www\.cupmakingmachines\.com/([a-z0-9\-/]+))(")',
        {
            param($m)
            $url = $m.Groups[1].Value
            if ($url -match '\.html$' -or $url -match '/$' -or $url -match '/news\.html$') { return $m.Value }
            return "$url.html$($m.Groups[3].Value)"
        })
    return $content
}

function Fix-ProductOffers([string]$content) {
    # Remove invalid zero-price AggregateOffer blocks (Google rich result violation)
    return [regex]::Replace($content,
        '"offers"\s*:\s*\{\s*"@type"\s*:\s*"AggregateOffer"[^}]*"price"\s*:\s*0\.0[^}]*\}',
        '"offers": { "@type": "Offer", "availability": "https://schema.org/InStock", "priceCurrency": "USD", "url": "' + $baseUrl + '/contact.html" }',
        $opts)
}

function Fix-HomepageSchema([string]$content) {
    # Remove SearchAction pointing to non-existent search.html
    $content = [regex]::Replace($content,
        ',\s*\{\s*"@context"\s*:\s*"https://schema\.org/"\s*,\s*"@type"\s*:\s*"WebSite"[^]]*?\}\s*\]',
        ']',
        $opts)
    $content = $content.Replace('"@context": "http://schema.org"', '"@context": "https://schema.org"')
    $content = $content.Replace('"logo": null', '"logo": "' + $baseUrl + '/upload/7728/20240727142829353292.png"')
    return $content
}

function Sync-OgWithCanonical([string]$content) {
    if ($content -match 'rel="canonical"\s+href="([^"]+)"' -or $content -match 'href="([^"]+)"\s+rel="canonical"') {
        $canonical = $Matches[1]
        $content = Set-OgMeta $content 'og:url' $canonical
    }
    return $content
}

$htmlUpdated = 0
$stats = @{ Keywords = 0; Descriptions = 0; Schema = 0; Og = 0 }

Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*' -and $_.FullName -notlike '*\Template\*'
} | ForEach-Object {
    $relative = $_.FullName.Substring($root.Length + 1)
    $content = [IO.File]::ReadAllText($_.FullName, [Text.UTF8Encoding]::new($false))
    $orig = $content

    if ($content -notmatch '<title>([^<]+)</title>') { return }
    $title = $Matches[1]

    $primary = Get-SlugKeyword $relative
    if (-not $primary) { $primary = ($title -split ' - ')[0].Trim() }

    $keywords = Get-PyramidKeywords $relative $title
    $content = Set-MetaTag $content 'keywords' $keywords
    if ($content -ne $orig) { $stats.Keywords++ }

    if ($content -match '<meta name="description" content="([^"]*)"') {
        $oldDesc = $Matches[1]
        $newDesc = Get-PyramidDescription $relative $primary $oldDesc
        if ($oldDesc -match '\\' -and $newDesc -eq $oldDesc) {
            $clean = $oldDesc -replace '\\', ''
            $newDesc = Get-PyramidDescription $relative $primary $clean
        }
        if ($newDesc -ne $oldDesc) {
            $newDesc = [regex]::Replace($newDesc, '\s+\S{1,4}\?(?=practical)', ' - ')
            $content = Set-MetaTag $content 'description' $newDesc
            $content = Set-OgMeta $content 'og:description' $newDesc
            $content = [regex]::Replace($content, '(<meta name="twitter:description" content=")[^"]*(")', "`${1}$newDesc`${2}", 1)
            $stats.Descriptions++
        }
    }

    $content = Sync-OgWithCanonical $content
    $content = Fix-SchemaUrls $content
    $content = Fix-ProductOffers $content
    $content = Fix-AbsoluteImageUrls $content $relative

    if ($relative -eq 'index.html') {
        $content = Fix-HomepageSchema $content
    }

    if ($content -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $content, [Text.UTF8Encoding]::new($false))
        $htmlUpdated++
    }
}

# --- Generate sitemap.xml ---
$sitemapExclude = @(
    'thank.html', 'ar\thank.html',
    'news\www.goldencupmachines.html', 'ar\news\www.goldencupmachines.html'
)

function Get-SitemapPriority([string]$relativePath) {
    $p = ($relativePath -replace '\\', '/').ToLower()
    if ($p -eq 'index.html' -or $p -eq 'ar/index.html') { return '1.0' }
    if ($p -match '^(ar/)?(about|products|contact|paper-cup-machine|paper-bowl-machine|news)\.html$') { return '0.9' }
    if ($p -match '/news/') { return '0.7' }
    return '0.8'
}

$urlEntries = [System.Collections.Generic.List[string]]::new()
Get-ChildItem -Path $root -Filter '*.html' -Recurse | Where-Object {
    $rel = $_.FullName.Substring($root.Length + 1)
    $rel -notin $sitemapExclude -and $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1) -replace '\\', '/'
    $lastmod = $_.LastWriteTime.ToString("yyyy-MM-dd")
    $loc = Get-CanonicalUrl $rel
    $priority = Get-SitemapPriority $rel
    $urlEntries.Add("<url><loc>$loc</loc><lastmod>$lastmod</lastmod><changefreq>weekly</changefreq><priority>$priority</priority></url>")
}

$sorted = $urlEntries | Sort-Object { if ($_ -match '<loc>([^<]+)</loc>') { $Matches[1] } else { $_ } }
$sitemapXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($sorted -join "`n")
</urlset>
"@
[IO.File]::WriteAllText((Join-Path $root 'sitemap.xml'), $sitemapXml, [Text.UTF8Encoding]::new($false))

# --- robots.txt ---
$robots = @"
User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml
"@
[IO.File]::WriteAllText((Join-Path $root 'robots.txt'), $robots, [Text.UTF8Encoding]::new($false))

Write-Host "SEO pyramid optimization complete."
Write-Host "  HTML files updated: $htmlUpdated"
Write-Host "  Keywords updated: $($stats.Keywords)"
Write-Host "  Descriptions improved: $($stats.Descriptions)"
Write-Host "  Sitemap URLs: $($sorted.Count)"
Write-Host "  Created: sitemap.xml, robots.txt"
