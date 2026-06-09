$root = Split-Path $PSScriptRoot -Parent
$count = 0
Get-ChildItem $root -Filter *.html -Recurse | Where-Object { $_.FullName -notlike '*\scripts\*' } | ForEach-Object {
    $c = [IO.File]::ReadAllText($_.FullName, [Text.UTF8Encoding]::new($false))
    $n = [regex]::Replace($c, '(\s)\S{1,4}\?(?=practical)', ' - ')
    if ($n -ne $c) {
        [IO.File]::WriteAllText($_.FullName, $n, [Text.UTF8Encoding]::new($false))
        $count++
    }
}
Write-Host "Fixed garbled chars in $count files"
