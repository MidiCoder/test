#This basic function creates multiple directories in the specified path..
Install-WindowsFeature -name Web-Server -IncludeManagementTools

Set-Location -path "C:\"
1..5 | ForEach-Object {New-Item -ItemType Directory .\PC"$_"}


