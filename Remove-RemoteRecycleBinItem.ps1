function Remove-RemoteRecycleBinItem {
    <#
    .SYNOPSIS
        Connects to a remote machine and removes a specific item from the $Recyle.Bin contents
    .DESCRIPTION
        Uses file names that are not the original file names from the Recycle Bin, but the metadata names ($RZYZ72E etc).
        You'll need to use Get-RemoteRecycleBin to ascertain which file you are trying to delete
    .PARAMETER user
        The SamAccountName of the users recycle bin that you are trying to retrieve
    .PARAMETER computer
        The host name of the computer that holds the recycele bin that you are trying to retrieve
    .PARAMETE file
        The file name that you are trying to delete.  Don't provide the leading $
    .NOTES
        Author: Joel Ashman
        v0.1 - (2021-09-01) Initial version
    .EXAMPLE
        . .\Remove-RemoteRecycleBinItem
        Remove-RemoteRecycleBinItem -user ashmanj -computer AUBNE1LT4088 -file 'RZYZ72E.txt'
    #>
    #requires -version 5
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$user,
        [Parameter(Mandatory)]
        [string]$computer,
        [Parameter(Mandatory)]
        [string]$file
    )
    $adModuleCheck = (Get-Module -ListAvailable | Where-Object { $_.Name -eq "ActiveDirectory"}).Name # Check if the AD module is loaded
    if ($adModuleCheck -eq "ActiveDirectory"){}
    else{ # Try to load the AD Powershell module if it isn't loaded
        Write-Warning "`n[!] The ActiveDirectory module is missing, trying to load it."
        try{Import-Module ActiveDirectory}
        catch{Write-Warning "`n[!] Problem with importing the ActiveDirectory module. $($Error[0])`nYou may need to install it with the following powershell one liner:`n`nGet-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online"}
    }
    # Get a Global Catalog for running AD queries
    $localSite = (Get-ADDomainController -Discover).Site;$newTargetGC = Get-ADDomainController -Discover -Service 2 -SiteName $localSite
    if (!$newTargetGC) {$newTargetGC = Get-ADDomainController -Discover -Service 2 -NextClosestSite};$localGC = "$($newTargetGC.HostName)" + ":3268"
    $sid = (Get-ADUser -filter "SamAccountName -eq '$user'" -server $localGC).SID.Value # Get the users SID for connecting to their recycle bin
    Invoke-Command -scriptblock { Remove-Item c:\`$Recycle.Bin\$Using:sid\`$$using:file} -computername $computer # Remove the file in question
}
