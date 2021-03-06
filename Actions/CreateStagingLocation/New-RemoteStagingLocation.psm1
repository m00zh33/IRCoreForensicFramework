function New-RemoteStagingLocation{
    <#
    .SYNOPSIS
    Creates a new folder on remote endpoint(s) to stage the data being gathered

    .DESCRIPTION
    Creates a new folder on the remote endpoint(s). This is used to stage the data to be extracted.
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$Target
    )

    # Set up outcome variable
    $outcome = @{
        "HostHunterObject" = "New-RemoteStagingLocation"
        "StagingLocation" = "C:\PerformanceInformation"
        "DateTime" = (Get-Date).ToString()
        "Target" = $Target
    }

    # Test the endpoint to see if the Performance Information folder exists, else create it
    $pathexists = Invoke-HostHunterCommand -Target $Target -ScriptBlock{
        # Set up output dictionary
        $output = @{}
        # Get Hostname of the command being run
        $output.Add("HostName", $env:COMPUTERNAME)
        # Test for the path
        $outcome = Test-Path -Path "C:\PerformanceInformation"
        # If outcome is false, create the directory
        if($outcome -eq $false){
            $output.Add("CreatedPerformanceInformationFolderTimestamp", (Get-Date).ToString())
            New-Item -Path "C:\" -Name "PerformanceInformation" -ItemType "directory"
        }
        # Record outcome for posterity
        $output.Add("Outcome", $outcome)
        Write-Output $output
    }

    # Add the results to outcome dictionary
    $outcome.Add("EndpointOutcomes", $pathexists)

    # Return results to pwsh
    Write-Output $outcome
}