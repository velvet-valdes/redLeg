# moveOut - pull up trails and GTFOD

Write-Host "moveOut `n"


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

$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops


# Echo user input varibles

Write-Host "Current Parameters: `n" -fore Yellow
Write-Host "Target Filter: " $filterTarget `n
Write-Host "Search Base: "
$searchBase | Format-Table
Write-Host "Operations Directory:" $opsDir


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
Write-Host "Here's the hostlist: "
$hostlist | Format-Table
Read-Host -Prompt "Press enter to MOVE OUT!!"


# Cycle through the clients in the host list and recursively remove the operations directory

foreach ($client in $hostList.Name)

{

  Write-Host "Sending command to.. $client"
  $cmdstring = “invoke-command -computername $client -scriptblock { If(test-path $opsDir) { write-host $client ‘Operations Directory = REMOVED’ ; Remove-Item -path $opsDir -Recurse -Force } Else { write-host 'Operations Directory = NON-EXISTANT' }}”
  $scriptblock = [scriptblock]::Create($cmdstring)
  Start-Process powershell -ArgumentList "-noexit -command $Scriptblock"

}


# Prompt user to close windows

Read-Host -Prompt "Press Enter to exit all other shells"


# Close all open powershell windows other than this one

Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru
