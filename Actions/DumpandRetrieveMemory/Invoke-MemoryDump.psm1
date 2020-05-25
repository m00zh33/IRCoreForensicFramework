function Invoke-MemoryDump{
    <#
    .SYNOPSIS
    Invokes memory dump on a remote endpoint
    .DESCRIPTION
    Uses WinPmem 1.6.2 on the remote endpoint to dump memory into performance data
    #>

    [CmdletBinding()]
    param (
        
    )

    $outcome = @{}
    # Run command
    Invoke-HostCommand -RegisterCommand -ScriptBlock{
        # Create outcome dictionary
        $outcome = @{}

        # Get the timestamp of the command
        $outcome.Add("MemoryDumpTimestamp", (Get-Date).ToString())
        
        # Test for path
        $path = Test-Path -LiteralPath "C:\PerformanceInformation\mem_info.exe"
        $outcome.Add("PathExists", $path)

        # Confirm enough space exists on endpoint
        # Get the total physical memory size 
        $ramsize = [Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName localhost).TotalPhysicalMemory/1Gb)
        # Check that there is enough space on disk
        $disk = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" ).FreeSpace/1GB
        # Setup outcome
        $outcome.Add("MemorySize", $ramsize)
        $outcome.Add("FreeDiskSpace", $disk)

        if($disk -gt $ramsize){
            $outcome.Add("EnoughSpace", $true)
            if($path -eq $true){
                C:\PerformanceInformation\mem_info.exe "C:\PerformanceInformation\memory.raw"
            }
        }else{
            $outcome.Add("EnoughSpace", $false)
        }
        Write-Output $outcome
    }
        
    Write-Output $outcome
}