Function Get-Ordinal {
    Param([int]$i)

    $Suffix = "thstndrd"

    [string]$i + $Suffix.Substring( 
        $(if ((($i/10)%10) -and ($i%10 -le 3) -and ($i%100 -lt 10 -or $i%100-gt 20)){$i%10*2}
        else{0}),2)

} #end Get-Ordinal

$list = @"
1 Partridge in a pear tree
2 Turtle Doves
3 French Hens
4 Calling Birds
5 Golden Rings
6 Geese a laying
7 Swans a swimming
8 Maids a milking
9 Ladies dancing
10 Lords a leaping
11 Pipers piping
12 Drummers drumming
"@

$Birds = "Partridge", "Dove", "Hen", "Bird", "Geese", "Swan"

$MatchString = "(?m)^(\d+)\s(.*$)"

$ListAsObjects = ([regex]$MatchString).Matches($list) | `
    % {[PSCustomObject] @{
    Amount=[int]$_.Groups[1].Value; 
    Item=$_.Groups[2].Value}
    }

for ($i=1;$i -le $ListAsObjects.Count;$i++) {
    Write-Output "`r`nOn the $(Get-ordinal $i) day of christmas, my truelove gave to me:"
    $ListAsObjects | ? {$_.Amount -le $i} | Sort-Object Amount -Descending | select Amount, Item | Ft -HideTableHeaders
}

Write-Output "`r`nSort by Length of Name`r`n--------------------"
$ListAsObjects | Sort-Object -Property {$_.Item.Length}

Write-Output "`r`n`r`nSum of Birds`r`n--------------------"
($ListAsObjects | ? {$_.Item -iMatch $($Birds -join "|")} | Measure-Object Amount -Sum).Sum

Write-Output "`r`n`r`nSum for all objects`r`n--------------------"
($ListAsObjects | Measure-Object Amount -Sum).Sum

Write-Output "`r`n`r`nCumulative sum of Birds`r`n--------------------"
($ListAsObjects | ? {$_.Item -iMatch $($Birds -join "|")} | select @{Name="Cumulative";expression={(13-$_.Amount)*$_.Amount}} | Measure-Object Cumulative -Sum).Sum

Write-Output "`r`n`r`nCumulative sum for all objects`r`n--------------------"
($ListAsObjects | select @{Name="Cumulative";expression={(13-$_.Amount)*$_.Amount}} | Measure-Object Cumulative -Sum).Sum

