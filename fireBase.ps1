# Get the needed variables from the user

Write-Host "fireBase `n"
$filterTarget = Read-Host "Enter Filter String"
$searchBase00 = Read-Host "Enter Search Base OU"
$searchBase01 = Read-Host "Enter Search Base DC"
$searchBase02 = Read-Host "Enter Search Base DC"
$opsDir = Read-Host "Enter Operations Directory Path"
$advanceParty = Read-Host "Enter Shell Script Path"


# Concatenate the search base

$searchBase = "OU=$searchBase00, DC=$searchBase01, DC=$searchBase02"


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