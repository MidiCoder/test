#This basic function creates multiple directories in the specified path..
Set-Location -path "C:\"
1..5 | ForEach-Object {New-Item -ItemType Directory .\PC"$_"}


