# Get the workstations in the active computers OU and filter out the weirdos. Store them in a host list.
$HostList=(Get-ADComputer -Filter "Name -like 'wkst*'" -SearchBase "OU=Active Computers, DC=camthebull, DC=net").name

foreach($client in $HostList )
{
    
    write-host "Sending command to $client"
    Invoke-Command -ComputerName $client -Scriptblock {Write-Host 'Terminating:' $client; Stop-Process -Name xmr-stak}

}

# Close all open powershell windows other than this one
Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru

# Quick hack for user input to keep window open
Read-Host -Prompt "Press Enter to exit"