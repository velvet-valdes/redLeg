# reinitGunline - reinitialize all cannons

Clear-Host
Write-Host "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
Write-Host "reinitGunline `n"


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

$filterTarget = $missionParameters.Target
$searchbase = $missionParameters.search


# Echo user input varibles

Write-Host "Current Parameters: `n" -fore Yellow
Write-Host "Target Filter: " $filterTarget `n
Write-Host "Search Base: "
$searchBase | Format-Table


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
Write-Host "Here's the hostlist: "
$hostlist | Format-Table
Read-Host -Prompt "Press enter to reinitialze the Gun Line..."


# Cycle through the clients in the host list sequentially and restart them.

foreach ($client in $hostList.Name)

{

  Write-Host "Sending command to $client"
  Restart-Computer -ComputerName $client -Force

}


# Close all open powershell windows other than this one

Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru


# Quick hack for user input to keep window open

Read-Host -Prompt "Press Enter to exit"

exit
