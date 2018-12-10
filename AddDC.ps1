<#
==========CREATE & ADD A DOMAIN CONTROLLER TO AN EXISTING DOMAIN ==========

1.        Create our parameters
2..       [Optional] If necessary initalise a disk, partition it, create a volume and format it for use as the location where you will install AD.
3...      Install AD Domain Services using Install-windowsfeature cmd
4....     Import ADDSDeployment PS Module see here https://docs.microsoft.com/en-us/powershell/module/addsdeployment/?view=win10-ps
5.....    Install-ADDSDomainController using Install-ADDSDomainController cmd

===========================================
#>

#1.
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [string]$AdminUser,

  [Parameter(Mandatory=$True)]
  [string]$AdminPassword,

  [Parameter(Mandatory=$True)]
  [string]$SafeModePassword,

  [Parameter(Mandatory=$True)]
  [string]$DomainName,

  [Parameter(Mandatory=$True)]
  [string]$SiteName

)

#2..
Initialize-Disk -Number 2 -PartitionStyle GPT
New-Partition -UseMaximumSize -DriveLetter F -DiskNumber 2
Format-Volume -DriveLetter F -Confirm:$false -FileSystem NTFS -force 

#3...
Install-windowsfeature -name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

#4....
Import-Module ADDSDeployment

$secSafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force
$secAdminPassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("$DomainName\$AdminUser", $secAdminPassword)

#5.....
Install-ADDSDomainController `
-Credential $credential `
-SafeModeAdministratorPassword $secSafeModePassword `
-CreateDnsDelegation:$false `
-DatabasePath "F:\Adds\NTDS" `
-DomainName $DomainName `
-SiteName $SiteName `
-NoGlobalCatalog:$false `
-CriticalReplicationOnly:$false `
-InstallDns:$true `
-LogPath "F:\Adds\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "F:\Adds\SYSVOL" `
-Force:$true