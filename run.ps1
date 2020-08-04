Remove-Module PsGetO365ServicePlanIDs -ErrorAction SilentlyContinue
Import-Module .\PsGetO365ServicePlanIDs.psd1

$md = ".\raw.md" ;
#Remove-Item $md -ErrorAction SilentlyContinue ;
Get-ServicePlanIDTableFromGitHub -Output $md

$csv = ".\table.csv"
Remove-Item $csv -ErrorAction SilentlyContinue ;
Convert-ServicePlanIDTable -InputFileMD $md | Export-Csv -NoTypeInformation $csv