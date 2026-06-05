# Replace dropdown language menu with direct EN/AR pill switcher
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"
$opts = [Text.RegularExpressions.RegexOptions]::Singleline

function Get-LangSwitchHtml([string]$enHref, [string]$arHref, [bool]$isAr, [string]$extraClass = '') {
    $arTitle = [string]::Concat([char]0x0627,[char]0x0644,[char]0x0639,[char]0x0631,[char]0x0628,[char]0x064A,[char]0x0629)
    if ($isAr) {
        return @"
<div class="lang-switch$extraClass">
    <a href="$enHref" class="lang-switch-btn" title="English">EN</a>
    <span class="lang-switch-btn is-active" title="$arTitle">AR</span>
</div>
"@
    }
    return @"
<div class="lang-switch$extraClass">
    <span class="lang-switch-btn is-active" title="English">EN</span>
    <a href="$arHref" class="lang-switch-btn" title="$arTitle">AR</a>
</div>
"@
}

$updated = 0

Get-ChildItem $root -Include *.html -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
    if ($content -notmatch 'lang_cont') { return }
    if ($content -match 'lang-switch-wrap') { return }

    $orig = $content
    $isAr = $_.FullName -like '*\ar\*'

    if ($content -notmatch 'language-flag-en"><a[^>]*href="([^"]*)"') {
        Write-Warning "Skip (no EN link): $($_.FullName)"
        return
    }
    $enHref = $Matches[1]
    if ($content -notmatch 'language-flag-ar"><a[^>]*href="([^"]*)"') {
        Write-Warning "Skip (no AR link): $($_.FullName)"
        return
    }
    $arHref = $Matches[1]

    $desktopSwitch = Get-LangSwitchHtml $enHref $arHref $isAr
    $mobileSwitch = Get-LangSwitchHtml $enHref $arHref $isAr ' lang-switch--mobile'

    $content = [regex]::Replace(
        $content,
        '<div class="lang_cont">\s*<div class="c_cont">.*?</ul>\s*</div>',
        "<div class=`"lang_cont lang-switch-wrap`">$desktopSwitch</div>",
        $opts
    )

    $content = [regex]::Replace(
        $content,
        '(<div class="mob-yuy">)\s*(<h3>.*?</h3>\s*)<ul class="lang">.*?</ul>',
        "`$1 lang-switch-mobile`$2$mobileSwitch",
        $opts
    )
    $content = $content.Replace('<div class="mob-yuy"> lang-switch-mobile<h3>', '<div class="mob-yuy lang-switch-mobile"><h3>')

    $content = [regex]::Replace(
        $content,
        '<style>\s*#header > \.nav > \.menu \.lang_cont \.lang \{.*?\}\s*#header > \.nav > \.menu \.lang_cont:hover \.lang \{.*?\}\s*#header > \.nav > \.menu \.lang_cont \.lang li \{.*?\}\s*</style>\s*',
        '',
        $opts
    )

    if ($isAr) {
        if ($content -notmatch 'lang-switcher\.css') {
            $content = $content -replace '(<link href="\.\./Template/316/css/language\.css" rel="stylesheet" type="text/css"\s*/>)', "`$1`r`n<link href=`"../Template/316/css/lang-switcher.css`" rel=`"stylesheet`" type=`"text/css`" />"
        }
    } else {
        if ($content -notmatch 'lang-switcher\.css') {
            $content = $content -replace '(<link href="Template/316/css/language\.css" rel="stylesheet" type="text/css"\s*/>)', "`$1`r`n<link href=`"Template/316/css/lang-switcher.css`" rel=`"stylesheet`" type=`"text/css`" />"
        }
    }

    if ($content -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $content, [Text.UTF8Encoding]::new($false))
        $updated++
    }
}

Write-Host "Done: $updated files updated"
