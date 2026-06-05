# Keep Facebook/LinkedIn icons but remove hyperlink navigation site-wide
$ErrorActionPreference = 'Stop'
$root = "C:\My Websites\zhibei\www.goldencupmachines.com"

$fbAr = [string]::Concat([char]0x0641,[char]0x064A,[char]0x0633,[char]0x0628,[char]0x0648,[char]0x0643)
$liAr = [string]::Concat([char]0x064A,[char]0x0646,[char]0x0643,[char]0x062F,[char]0x064A,[char]0x0646)

$updated = 0

Get-ChildItem $root -Include *.html,*.xml -Recurse | Where-Object {
    $_.FullName -notlike '*\scripts\*'
} | ForEach-Object {
    $content = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
    $orig = $content
    $isAr = $_.FullName -like '*\ar\*'

    if ($isAr) {
        $fb = "<a title=`"$fbAr`" rel=`"nofollow`"><i class=`"fa fa-facebook`"></i></a>"
        $li = "<a title=`"$liAr`" rel=`"nofollow`"><i class=`"fa fa-linkedin`"></i></a>"
    } else {
        $fb = '<a title="Facebook" rel="nofollow"><i class="fa fa-facebook"></i></a>'
        $li = '<a title="LinkedIn" rel="nofollow"><i class="fa fa-linkedin"></i></a>'
    }

    # Footer share area
    if ($content -match 'class="share"' -and $content -notmatch 'fa fa-facebook') {
        $content = [regex]::Replace(
            $content,
            '(<div class="share">\s*)<a href="https://api\.whatsapp\.com/send\?phone=8618151132311(&amp;|&)text=Hello"',
            { param($m) "$($m.Groups[1].Value)$fb$li<a href=`"https://api.whatsapp.com/send?phone=8618151132311$($m.Groups[2].Value)text=Hello`"" }
        )
    }

    # AddToAny share widgets (independent of footer icons)
    if ($content -match 'a2a_button_x') {
        $content = [regex]::Replace(
            $content,
            '(<div class="a2a_kit a2a_kit_size_32 a2a_default_style">)\s*(?=<a class="a2a_button_x"></a>)',
            "`$1$fb"
        )
        $content = [regex]::Replace(
            $content,
            '(<a class="a2a_button_pinterest"></a>)\s*(?=<a class="a2a_dd")',
            "`$1$li"
        )
    }

    # Strip href from profile links if present
    $content = [regex]::Replace(
        $content,
        '<a href="https://www\.facebook\.com/shi\.tina\.395"([^>]*)><i class="fa fa-facebook"></i></a>',
        $fb
    )
    $content = [regex]::Replace(
        $content,
        '<a href="https://www\.linkedin\.com/in/vicky-shi-1426461ba/"([^>]*)><i class="fa fa-linkedin"></i></a>',
        $li
    )
    $content = [regex]::Replace($content, '\s*<a class="a2a_button_facebook"></a>\s*', $fb)
    $content = [regex]::Replace($content, '\s*<a class="a2a_button_linkedin"></a>\s*', $li)

    if ($content -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $content, [Text.UTF8Encoding]::new($false))
        $updated++
    }
}

Write-Host "Done: $updated files updated"
