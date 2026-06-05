# Remove all video elements and containers site-wide without leaving empty gaps
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

$updated = 0

function Clean-VideoHtml([string]$content) {
    # xsl-350t: remove video product-intro section, toggle, styles, scripts; show image gallery
    if ($content -match 'intro-video') {
        $content = [regex]::Replace(
            $content,
            '<section class="product-intro" style="">\s*<div class="intro-video">.*?</section>\s*',
            '',
            $opts
        )
        $content = [regex]::Replace(
            $content,
            '<div class="product-video">\s*<div class="pvideo-main">.*?</div>\s*</div>\s*',
            '',
            $opts
        )
        $content = [regex]::Replace(
            $content,
            '<style>\s*\.product-video.*?</style>\s*',
            '',
            $opts
        )
        $content = [regex]::Replace(
            $content,
            '<script language="javascript">\s*\$\("\.pvideo-main>div"\).*?\$\("\.opclose"\).*?</script>\s*',
            '',
            $opts
        )
        $content = $content.Replace('<section class="product-intro" style="display: none;">', '<section class="product-intro">')
        # Fix orphaned closing divs left after video block removal
        $content = [regex]::Replace(
            $content,
            '(</section>\s*)\s*</div>\s*</div>\s*(<div class="showpr-right">)',
            '$1</div>$2',
            $opts
        )
    }

    # About page video-only container
    $content = [regex]::Replace(
        $content,
        '<div class="_about_items">\s*<iframe[^>]*youtube\.com/embed[^>]*>\s*</iframe>\s*</div>\s*',
        '',
        $opts
    )

    # YouTube iframes
    $content = [regex]::Replace(
        $content,
        '<iframe[^>]*youtube\.com/embed[^>]*>\s*</iframe>\s*',
        '',
        $opts
    )

    # HTML5 video elements
    $content = [regex]::Replace($content, '<video[^>]*>.*?</video>\s*', '', $opts)

    # trade-cloud video iframes (if any)
    $content = [regex]::Replace(
        $content,
        '<iframe[^>]*video\.trade-cloud[^>]*>\s*</iframe>\s*',
        '',
        $opts
    )

    # Remove paragraphs that only held videos or spacing
    for ($i = 0; $i -lt 5; $i++) {
        $next = [regex]::Replace($content, '<p>\s*(<br\s*/?\s*>\s*)?</p>\s*', '', $opts)
        if ($next -eq $content) { break }
        $content = $next
    }

    return $content
}

Get-ChildItem $root -Include *.html,*.xml -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
    $orig = $content
    $content = Clean-VideoHtml $content
    if ($content -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $content, [Text.UTF8Encoding]::new($false))
        $updated++
    }
}

Write-Host "Done: $updated files updated"
