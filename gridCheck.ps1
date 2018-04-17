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
$searchBase = $missionParameters.search.distinguishedname


# Set variables from the newly created object

$opsDir = $missionParameters.ops
$filterTarget = $missionParameters.Target
$advanceParty = $missionParameters.ap

Write-Host "Operations Directory Path: $opsDir"
Write-Host "Advance Party Path: $advanceParty"
Write-Host "Active Directory Filter String: $filterTarget"
Write-Host "Selected Organizationl Unit: $selectedOU"
Write-Host "Active Directory Search Base: $searchBase"

Read-Host -Prompt "Press Enter to exit"

exit
