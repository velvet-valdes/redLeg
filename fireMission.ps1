# Get the workstations in the active computers OU and filter out the weirdos. Store them in a host list.
$HostList=(Get-ADComputer -Filter "Name -like 'wkst*'" -SearchBase "OU=Active Computers, DC=camthebull, DC=net").name

# Operate on the objects stored in the host list variable
#Uncomment below to echo the scriptblock into console. 
$scriptblock

foreach($client in $HostList )
{
    
    write-host "Sending command to.. $client"
    $cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client; & ‘C:\RSAT\xmr-stak-win64\xmr-stak.exe’ -c 'C:\RSAT\xmr-stak-win64\config.txt' -C 'C:\RSAT\xmr-stak-win64\pools.txt'}"
    $scriptblock = [scriptblock]::Create($cmdstring)

    start-process powershell -argumentlist "-noexit -command $Scriptblock"
}