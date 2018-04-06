# Get the workstations in the active computers OU and filter out the weirdos. Store them in a host list.
$HostList=(Get-ADComputer -Filter "Name -like 'wkst*'" -SearchBase "OU=Active Computers, DC=camthebull, DC=net").name

# Cycle through the clients in the host list and recursively remove the operations directory
$opsDir = "C:\RSAT"

foreach($client in $HostList )
{
    
    write-host "Sending command to.. $client"
    $cmdstring = "invoke-command -computername $client -scriptblock {write-host $client 'MOVING OUT!' ; Remove-Item -path $opsDir -Recurse -Force}"
    $scriptblock = [scriptblock]::Create($cmdstring)

    start-process powershell -argumentlist "-noexit -command $Scriptblock"

}

# Prompt user to close windows
Read-Host -Prompt "Press Enter to exit all other shells"

# Close all open powershell windows other than this one
Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru