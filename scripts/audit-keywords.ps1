$root = 'C:\My Websites\zhibei\www.goldencupmachines.com'
$total = 0; $hasKiwl = 0; $noKiwl = @(); $weak = @(); $generic = 0; $noMeta = @()

Get-ChildItem $root -Filter *.html -Recurse | Where-Object { $_.FullName -notlike '*\scripts\*' } | ForEach-Object {
    $c = [IO.File]::ReadAllText($_.FullName, [Text.UTF8Encoding]::new($false))
    $rel = $_.FullName.Substring($root.Length + 1)
    if ($c -notmatch '<meta name="keywords" content="([^"]*)"') {
        $noMeta += $rel
        return
    }
    $total++
    $kw = $Matches[1]
    if ($kw -match 'KIWL') { $hasKiwl++ } else { $noKiwl += "$rel | $kw" }
    if ($kw -match '^(About Us|Industry News|Company News|Products|Download|Contact Us|Send Inquiry|Privacy Policy|Links|Sitemap|Thank), KIWL') {
        $weak += $rel
    }
    if ($kw -match ', KIWL, KIWL Machinery, KIWL paper cup machine$') { $generic++ }
}

Write-Host "Pages with keywords meta: $total"
Write-Host "Pages with KIWL in keywords: $hasKiwl"
Write-Host "Pages WITHOUT keywords meta: $($noMeta.Count)"
Write-Host "Weak primary keyword (generic page name only): $($weak.Count)"
Write-Host "Pages with generic KIWL suffix appended: $generic"
if ($noMeta.Count) { Write-Host "`nNo keywords meta:"; $noMeta }
if ($noKiwl.Count) { Write-Host "`nNo KIWL in keywords:"; $noKiwl }
if ($weak.Count) { Write-Host "`nWeak keyword samples:"; $weak | Select-Object -First 20 }
