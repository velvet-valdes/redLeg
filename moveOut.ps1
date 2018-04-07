# Get the needed variables from the user

$filterTarget = Read-Host "Enter Filter String"
$searchBase00 = Read-Host "Enter Search Base OU"
$searchBase01 = Read-Host "Enter Search Base DC"
$searchBase02 = Read-Host "Enter Search Base DC"
$opsDir = Read-Host "Enter Operations Directory Path"
$searchBase = "OU=$searchBase00, DC=$searchBase01, DC=$searchBase02"

Write-Host $filterTarget
Write-Host $searchBase


# Get the hosts in the search base and filter based on user input. Store them in a host list.

$HostList=(Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $searchBase).name


# Cycle through the hosts in the host list and recursively remove the operations directory

foreach($client in $HostList )
{
    
    write-host "Sending command to.. $client"
    $cmdstring = “invoke-command -computername $client -scriptblock { If(test-path $opsDir) { write-host $client ‘Operations Directory = REMOVED’ ; Remove-Item -path $opsDir -Recurse -Force } Else { write-host 'Operations Directory = NON-EXISTANT' }}”
    $scriptblock = [scriptblock]::Create($cmdstring)
    start-process powershell -argumentlist "-noexit -command $Scriptblock"

}


# Prompt user to close windows

Read-Host -Prompt "Press Enter to exit all other shells"


# Close all open powershell windows other than this one

Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru