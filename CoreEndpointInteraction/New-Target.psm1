function New-Target{
    <#
    .SYNOPSIS
        Creates a new target to be targeted 
    .DESCRIPTION
        Creates a new target to be targeted
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string[]]$Target
    )

    # Confirm if creds variable is set
    if ($cred -eq $null){
        $cred = Get-Credential
    }

    # Iterate through the input target and setup sessions
    foreach ($endpoint in $Target){
        # Check if already in list
        if($GlobalTargetList.ContainsKey($endpoint)){
            $message = "Target " + $endpoint + " already exists"
            Write-ColoredInformation -MessageData $message
        }else{
            New-EndpointSession -Target $endpoint -Credential $cred
        }
    }

    # At the end of adding them all all, give the user a list of targets
    Get-TargetList

}