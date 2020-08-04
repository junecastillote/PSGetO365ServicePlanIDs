Function Get-ServicePlanIDTableFromGitHub {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$Output,

        [parameter()]
        [string]$URL = "https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/active-directory/users-groups-roles/licensing-service-plan-reference.md"
    )

    try {
        #(New-Object System.Net.WebClient).DownloadFile($URL, $Output)
        Invoke-WebRequest -Uri $url -OutFile $Output -ErrorAction STOP
        Write-Verbose "File downloaded to $Output"
    }
    catch {
        Write-Output "An error has occured"
        Write-Output $_.ErrorDetails.Message
    }
}

Function Convert-ServicePlanIDTable {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$InputFileMD
    )

    try {
        $xtable = get-content $InputFileMD -ErrorAction STOP
    }
    catch {
        Write-Output "An error occured"
        Write-Output $_.ErrorDetails.Message
        return $null
    }

    ## Find the start of the table and mark it with 'StartHere'
    $i = 0
    foreach ($line in $xtable) {
        if ($line -eq '| Product name | String ID | GUID | Service plans included | Service plans included (friendly names) |') {
            $startLine = $i
            break
        }
        $i++
    }

    ## Find the end of the table and mark it with 'EndHere'
    $i = 0
    foreach ($line in $xtable) {
        if ($line -eq '## Service plans that cannot be assigned at the same time') {
            $endLine = ($i - 1)
            break
        }
        $i++
    }

    ## Extract the string in between the lines $startLine and $endLine
    $result = @()
    for ($i = $startLine; $i -lt $endLine; $i++) {
        if ($xtable[$i] -notlike "*---*") {
            $result += ($xtable[$i].Substring(1,$xtable[$i].Length-1)) -replace "\s*\|\s*", "|" -replace "<br/>",";"
        }
    }

    $result = $result | ConvertFrom-Csv -Delimiter "|"
    return $result
}