# gridCheck - JSON file object conversion

Write-Host "gridCheck `n"


# Test to see if JSON configuration exists

if (!(Test-Path fireDirectionalControl.json))

{

Write-Host "WARNING - !!MISSION COORDINATES NOT FOUND!! - WARNING`n"
Write-Host "Aborting attempted command...`n"
Write-Host `n
Invoke-Expression -Command .\gridCoordinates.ps1

}


# Load the fireDirectionalControl JSON config file into an object

$missionParameters = (Get-Content -Raw -Path fireDirectionalControl.json | ConvertFrom-Json) 
# Concatenate the search base

$selectedOU = $missionParameters.search.Name
$searchBase = $missionParameters.search.DistinguishedName


# Set variables from the newly created object

$opsDir = $missionParameters.ops
$filterTarget = $missionParameters.target
$advanceParty = $missionParameters.ap

Write-Host "Operations Directory Path: $opsDir"
Write-Host "Advance Party Path: $advanceParty"
Write-Host "Active Directory Filter String: $filterTarget"
Write-Host "Selected Organizationl Unit: $selectedOU"
Write-Host "Active Directory Search Base: $searchBase"

Read-host -Prompt "Press Enter to exit"

exit