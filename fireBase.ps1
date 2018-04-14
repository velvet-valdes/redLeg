# fireBase - emplace cannons and form the gun line

Write-Host "fireBase `n"


# Test to see if JSON configuration exists

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
if (!(Test-Path $fireDirectionalControl))

{

Write-Host "WARNING - !!MISSION COORDINATES NOT FOUND!! - WARNING`n"
Write-Host "Aborting attempted command...`n"
Write-Host `n
Invoke-Expression "& ${psscriptroot}\gridCoordinates.ps1"

}

# Load the fireDirectionalControl JSON config file into an object

$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)

# Pull the search base and needed variables from the loaded JSON config

$opsDir = $missionParameters.ops
$filterTarget = $missionParameters.target
$advanceParty = $missionParameters.ap
$searchbase = $missionParameters.search


# Echo user input varibles

Write-Host "Current Parameters: `n" -fore Yellow
Write-Host "Target Filter: "$filterTarget `n
Write-Host "Search Base: "
$searchBase | FT
Write-Host "Advance Party Orders:" $advanceParty
Write-Host "Operations Directory:" $opsDir


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$hostList = $searchbase | Foreach{Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname} | select Name
write-host "Here's the hostlist: "
$hostlist | FT 
Read-Host -Prompt "Press enter to emplace fireBase..." 


# Cycle through the clients in the host list and call the advanceParty script to be executed on them

foreach($client in $hostList.Name )

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