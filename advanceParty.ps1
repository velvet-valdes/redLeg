﻿    
# Replace hard coded wallet address with variable $walletAddress
# Replace currency type with variable $currencyType
# Replace pool address with variable $poolAddress
# Replace pool port with variable $poolPort

# Accept a paramter for the operations directory which is stored in the JSON configbeing passed in via the pipline
# Update this to include the variables listed above and add them to the fireBase function
param(
	[Parameter(Mandatory = $True,
		ValueFromPipeline = $True)]
	[string]$opsDir,
	[string]$distName,
	[string]$stakName,
	[string]$stakVersion,
	[string]$walletAddress,
	[string]$currencyType,
	[string]$poolAddress,
	[string]$poolPort
)

# Advance Party functions
function stripExcess ($template) {
	# strip out unneeded characters from the configuration templates
	$head = 'R"===('
	$tail = ')==="'
	$template = $template.Replace($head,"")
	$template = $template.Replace($tail,"")
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
	(Get-Content "$file") | ForEach-Object { $_ -replace "POOLCONF",'{"pool_address" : "DESTINATION:DESTPORT", "wallet_address" : "ACCOUNT", "rig_id" : "", "pool_password" : "COMPUTERNAME", "use_nicehash" : false, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },' } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace "DESTINATION" , $poolAddress } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace "DESTPORT" , $poolPort } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace "ACCOUNT" , $walletAddress } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace "COMPUTERNAME","$env:COMPUTERNAME" } | Set-Content "$file"
	(Get-Content "$file") | ForEach-Object { $_ -replace '"currency" : "CURRENCY"',"`"currency`" : `"$currencyType`"" } | Set-Content "$file"
	
}

# Check to see if the Visual C++ Redistributable is installed
$redistDestination = "$opsDir\vc_redist.x64.exe"
$uninstallValue = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion | Where-Object { $_.DisplayName -like '*Microsoft Visual C++*' } | Where-Object DisplayVersion -GT 14.16.27023
$installValue = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion | Where-Object { $_.DisplayName -like '*Microsoft Visual C++*' }
if ($null -eq $uninstallValue)
{
	Write-Host "`nAttempting to install Microsoft Visual C++ Redistibutable..."
	Invoke-Expression "& '$redistDestination' /install /passive /norestart"
	Write-Host "Installed!`n"
}
else
{
	Write-Host "`n"
	Write-Host $installValue.DisplayName | Format-Table
	Write-Host "Currently Installed.`n"
	Start-Sleep -s 1
}

# Unzip the payload
$payloadDestination = "$opsDir" + "\" + $stakName + "-" + "$stakVersion" + ".zip"
Expand-Archive -LiteralPath $payloadDestination -DestinationPath $opsDir

# Load the newly unzipped directory path into a variable and set the destiation path to extract the config.
$unzipDir = Get-ChildItem -Path $opsDir -Directory -Name
$stakDir = "$opsDir\$unzipDir"

# Modify the config.tpl file and save it to a text file
$config = Get-Content "$opsDir\config.tpl" -Raw
stripExcess ($config) | Out-File "$stakDir\config.txt"
alterConfigTpl "$stakDir\config.txt"

# Modify the pools.tpl file and save it to a text file
$pools = Get-Content "$opsDir\pools.tpl" -Raw
stripExcess ($pools) | Out-File "$stakDir\pools.txt"
alterPoolTpl "$stakDir\pools.txt" $currencyType

write-host $opsDir
write-host $distName
write-host $stakName
write-host $stakVersion
write-host $walletAddress
write-host $currencyType
write-host $poolAddress
write-host $poolPort

# Cleanup the cruft
Remove-Item "$opsDir\pools.tpl"
Remove-Item "$opsDir\config.tpl"
Remove-Item "$opsDir\$distName"
Remove-Item $payloadDestination