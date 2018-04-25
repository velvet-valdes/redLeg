# fireMission - fire all cannons

Clear-Host
Write-Host "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
Write-Host "fireMission `n"


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
Write-Host "Ops Directory: " $opsDir `n


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
Write-Host "Here's the hostlist: "
$hostlist | Format-Table
Read-Host -Prompt "Press enter to commence fireMission!"


# Cycle through the clients in the host list and launch xmr-stak

foreach ($client in $hostList.Name)

{

  Write-Host "Sending command to.. $client"
  $cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client ; & ‘$opsDir\xmr-stak-win64\xmr-stak.exe’ -c '$opsDir\xmr-stak-win64\config.txt' -C '$opsDir\xmr-stak-win64\pools.txt'}"
  $scriptblock = [scriptblock]::Create($cmdstring)
  Start-Process powershell -ArgumentList "-noexit -command $Scriptblock"

}
