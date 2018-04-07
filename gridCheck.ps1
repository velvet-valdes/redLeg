# Parse the fireDirectionalControl file to load the JSON into an object
$missionParameters = (Get-Content -Raw -Path C:\Users\Administrator\Documents\WindowsPowerShell\redleg\fireDirectionalControl.json | ConvertFrom-Json) #don't forget to un-hardcode that path!

# Concatenate the search base 

$searchBase00 = $missionParameters.search[0]
$searchBase01 = $missionParameters.search[1]
$searchBase02 = $missionParameters.search[2]
$searchBase = "DC=$searchBase00, OU=$searchBase01, OU=$searchBase02"

Write-Host "Operations Directory Path:" $missionParameters.ops
Write-Host "Payload Path:" $missionParameters.payload
Write-Host "Advance Party Path:" $missionParameters.ap
Write-Host "Active Directory Filter String:" $missionParameters.target
Write-Host "Active Directory Search Base:" $searchBase

Read-host -Prompt "Press Enter to exit"