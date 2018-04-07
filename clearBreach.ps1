# clearBreach - cease firing all cannons

Write-Host "clearBreach `n"


# Load the fireDirectionalControl JSON config file into an object

$missionParameters = (Get-Content -Raw -Path fireDirectionalControl.json | ConvertFrom-Json) 


# Concatenate the search base

$searchBase00 = $missionParameters.search[0]
$searchBase01 = $missionParameters.search[1]
$searchBase02 = $missionParameters.search[2]
$searchBase = "OU=$searchBase00, DC=$searchBase01, DC=$searchBase02"

# Parse and load variables from JSON

$filterTarget = $missionParameters.target


# Echo user input varibles

Write-Host "Current Parameters `n"
Write-Host $filterTarget
Write-Host $searchBase
Read-Host -Prompt "Press Enter to continue"


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$HostList=(Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $searchBase).name


# Cycle through the clients in the host list sequentially and terminate xmr-stak.

foreach($client in $HostList )

{
    
    write-host "Sending command to $client"
    Invoke-Command -ComputerName $client -Scriptblock {Write-Host 'Terminating:' $client; Stop-Process -Name xmr-stak}

}


# Close all open powershell windows other than this one

Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru


# Quick hack for user input to keep window open

Read-Host -Prompt "Press Enter to exit"