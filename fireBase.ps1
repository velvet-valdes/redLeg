# fireBase - emplace cannons and form the gun line

Write-Host "fireBase `n"


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

$searchBase00 = $missionParameters.search[0]
$searchBase01 = $missionParameters.search[1]
$searchBase02 = $missionParameters.search[2]
$searchBase = "OU=$searchBase00, DC=$searchBase01, DC=$searchBase02"

# Set variables from the newly created object

$opsDir = $missionParameters.ops
$filterTarget = $missionParameters.target
$advanceParty = $missionParameters.ap


# Echo user input varibles

Write-Host "Current Parameters `n"
Write-Host $filterTarget
Write-Host $searchBase
Write-Host $advanceParty
Read-Host -Prompt "Press Enter to continue"


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$HostList=(Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $searchBase).name


# Cycle through the clients in the host list and call the advanceParty script to be executed on them

foreach($client in $HostList )

{
    
    write-host "Sending command to.. $client"
    $cmdstring = "invoke-command -computername $client -FilePath $advanceParty"
    $scriptblock = [scriptblock]::Create($cmdstring)
    start-process powershell -argumentlist "-noexit -command $Scriptblock"

}

# Prompt user to close windows

Read-Host -Prompt "Press Enter to exit all other shells"


# Close all open powershell windows other than this one

Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru