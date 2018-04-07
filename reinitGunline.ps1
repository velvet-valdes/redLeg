# Get the needed variables from the user

Write-Host "reinitGunline `n"
$filterTarget = Read-Host "Enter Filter String"
$searchBase00 = Read-Host "Enter Search Base OU"
$searchBase01 = Read-Host "Enter Search Base DC"
$searchBase02 = Read-Host "Enter Search Base DC"


# Concatenate the search base

$searchBase = "OU=$searchBase00, DC=$searchBase01, DC=$searchBase02"


# Echo user input varibles

Write-Host "Current Parameters `n"
Write-Host $filterTarget
Write-Host $searchBase
Read-Host -Prompt "Press Enter to continue"


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$HostList=(Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $searchBase).name


# Cycle through the clients in the host list and restart them sequentially.

foreach($client in $HostList )
{
    
    write-host "Sending command to $client"
    Restart-Computer -ComputerName $client -force

}

# Close all open powershell windows other than this one
Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru

# Quick hack for user input to keep window open
Read-Host -Prompt "Press Enter to exit"