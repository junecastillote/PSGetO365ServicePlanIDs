Function Get-O365ServicePlanIDTable {
    [CmdletBinding()]

    ## This is the licensing reference table document from GitHub
    [string]$URL = 'https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/active-directory/enterprise-users/licensing-service-plan-reference.md'

    ## Download the string value of the MD file
    [System.Collections.ArrayList]$raw_Table = ((New-Object System.Net.WebClient).DownloadString($URL) -split "`n")
    ## Determine the starting row index of the table
    $startLine = $raw_Table.IndexOf('| Product name | String ID | GUID | Service plans included | Service plans included (friendly names) |')
    ## Determine the ending index of the table
    $endLine = ($raw_Table.IndexOf('## Service plans that cannot be assigned at the same time') - 1)
    ## Extract the string in between the lines $startLine and $endLine
    $result = @()
    for ($i = $startLine; $i -lt $endLine; $i++) {
        if ($raw_Table[$i] -notlike "*---*") {
            $result += ($raw_Table[$i].Substring(1, $raw_Table[$i].Length - 1))
        }
    }
    $result = $result `
        -replace '\s*\|\s*', '|' `
        -replace '\s*\(', ' (' `
        -replace '\s*<br/>\s*', ';' `
        -replace '\(\(', '(' `
        -replace '\)\)', ')' `
        -replace '\)\s*\(', ')('

    #$result = (($result | ConvertFrom-Csv -Delimiter "|").'Service plans included (friendly names)') -split ";" | Sort-Object -Unique
    $result = (($result | ConvertFrom-Csv -Delimiter "|"))

    return $result
}