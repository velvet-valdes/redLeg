# Get the needed variables from the user

Write-Host "redLeg JSON Variable Creator `n"
$filterTarget = Read-Host "Enter Active Directory Filter String"
$searchBase00 = Read-Host "Enter Active Directory Search Base OU"
$searchBase01 = Read-Host "Enter Active Directory Search Base DC prefix"
$searchBase02 = Read-Host "Enter Active Directory Search Base DC suffix"
$opsDir = Read-Host "Enter Target Operations Directory Path"
$redLeg = Read-Host "Enter redLeg path"

# Concatenate variables
$configPath = "$opsDir\fireDirectionalControl.json"
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