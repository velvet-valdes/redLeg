# gridCoordinates - JSON config file generator

Write-Host "gridCoordinates `n"


# Test to see if JSON configuration exists

if (Test-Path fireDirectionalControl.json)

{
    Write-Host "File Exists -  Rename or delete fireDirectionalControl.json from the local redLeg directory.`n"
    Read-Host -Prompt "Hit enter to exit..."
    exit
} 

else { Write-Host "Grid Coordinates have not been entered.  Enter target values now:`n" }



# Get the needed input from the user

$filterTarget = Read-Host "Enter Active Directory Filter String"
$searchBase00 = Read-Host "Enter Active Directory Search Base OU"
$searchBase01 = Read-Host "Enter Active Directory Search Base DC prefix"
$searchBase02 = Read-Host "Enter Active Directory Search Base DC suffix"
$opsDir = Read-Host "Enter REMOTE Target Operations Directory Path"
$redLeg = Read-Host "Enter LOCAL redLeg Directory Path"


# Concatenate variables

$configPath = "$redLeg\fireDirectionalControl.json"
$advanceParty ="$redLeg\advanceParty.ps1"


# Create hashtable out of user input

$storedSettings = @{
   
    ops = $opsDir
    payload = $opsDir
    ap = $advanceParty
    target = $filterTarget
    search = @($searchBase00,$searchBase01,$searchBase02)

}


# Convert hashtable to JSON and save to a file

$storedSettings | ConvertTo-Json | Out-File $configPath


# Test and give verbose feedback

If (Test-Path $configPath)

{ Write-Host "JSON configuration successfully created" } 

Else

{ Write-Host "JSON configuration FAILED" }


Read-Host -Prompt "Press Enter to exit"


exit