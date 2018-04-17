# clearBreach - cease firing all cannons

Write-Host "clearBreach `n"


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

Write-Host "Current Parameters `n"
Write-Host $filterTarget
$searchBase | Format-Table
Read-Host -Prompt "Press Enter to continue"


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
Write-Host "Here's the hostlist: "
$hostlist | Format-Table


# Cycle through the clients in the host list sequentially and terminate xmr-stak.

foreach ($client in $hostList.Name)

{

  Write-Host "Sending command to $client"
  Invoke-Command -ComputerName $client -ScriptBlock { Write-Host 'Terminating:' $client; Stop-Process -Name xmr-stak }

}


# Close all open powershell windows other than this one

Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru


# Quick hack for user input to keep window open

Read-Host -Prompt "Press Enter to exit"

exit
