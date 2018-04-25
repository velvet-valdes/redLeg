# gridCheck - JSON file object conversion

Clear-Host
Write-Host "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
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


# Loop through the object and place the values in a hash tables

$hash = @{}
foreach ($property in $missionParameters.PSObject.Properties) {
    $hash[$property.Name] = $property.Value
}


# Echo the mission parameters to the screen
$hash | Format-Table -AutoSize -Wrap
Read-Host -Prompt "Press Enter to exit"

exit