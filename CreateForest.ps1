<#
==========CREATE A NEW AD FOREST==========

1.        Create our parameters
2..       [Optional] If necessary initalise a disk, partition it, create a volume and format it for use as the location where you will install AD.
3...      Install AD Domain Services using Install-windowsfeature cmd
4....     Import ADDSDeployment PS Module see here https://docs.microsoft.com/en-us/powershell/module/addsdeployment/?view=win10-ps
5.....    Install-ADDSForest using Install-ADDSForest cmd

===========================================
#>

#1.
[CmdletBinding()]
Param(
	[string]$SafeModePassword = "SafeModeP@ssw0rd",
	[string]$DomainName = "contoso.com",
	[string]$DomainNetbiosName = "CONTOSO"
)

$ErrorActionPreference = "Stop"

#2..
Initialize-Disk -Number 2 -PartitionStyle GPT
New-Partition -UseMaximumSize -DriveLetter F -DiskNumber 2
Format-Volume -DriveLetter F -Confirm:$false -FileSystem NTFS -force 

#3...
Install-windowsfeature -name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

#4....
Import-Module ADDSDeployment

$secSafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

#5.....
Install-ADDSForest `
-SafeModeAdministratorPassword $secSafeModePassword `
-CreateDnsDelegation:$false `
-DatabasePath "F:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName $DomainName `
-DomainNetbiosName $DomainNetbiosName `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "F:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "F:\Windows\SYSVOL" `
-Force:$true