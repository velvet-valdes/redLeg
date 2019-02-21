# Unified Advance Party Script - Functions included until I find an elegant way to send 
# separate files for the functions in the AP setup process

# Accept a paramter for the operations directory which is stored in the JSON config

param(
  [Parameter(Mandatory = $True,
    ValueFromPipeline = $True)]
  [string]$opsDir,
  [string]$cache,
  [string]$phoneHome,
  [string]$distName,
  [string]$stakName,
  [string]$stakVersion
)

# Advance Party functions

function redist ($destination) { #change to point at ops cache and rename function
  
  $itemPath = "\\" + $phoneHome + "\" + "ops_cache" + "\" + $distName
  Write-Host $itemPath
  Copy-Item -Path $itemPath.path -Destination $destination
  Read-Host "enter"
}

function payload ($destination) { #change to point at ops cache and rename function

  $itemPath = "\\" + $phoneHome + "\" + "ops_cache" + "\" +  $stakName + "-" + "$stakVersion" + ".zip"
  Write-Host $itemPath
  Copy-Item -Path "filesystem::$itemPath" -Destination $destination
  Read-Host "enter"
}

function configTpl () { #change to point at ops cache and rename function

  $itemPath = "\\" + $phoneHome + "\" + "ops_cache" + "\" + "config.tpl"
  Write-Host $itemPath
  Copy-Item -Path $itemPath -Destination $opsDir
  Read-Host "enter"

}

function poolTpl () { #change to point at ops cache and rename function

  $itemPath = "\\" + $phoneHome + "\" + "ops_cache" + "\" + "pools.tpl"
  Write-Host $itemPath
  Copy-Item -Path $itemPath -Destination $opsDir
  Read-Host "enter"

}


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

  (Get-Content "$file") | ForEach-Object { $_ -replace '"currency" : "CURRENCY"','"currency" : "aeon7"' } | Set-Content "$file"
  (Get-Content "$file") | ForEach-Object { $_ -replace "POOLCONF",'{"pool_address" : "pool.aeonminingpool.com:3335", "wallet_address" : "Wmt1MRyhVkffvWShqLBbytMWfdkRhzago6wHn61cgnMEMDEm5HNMsdmBycerj5iJVFjkEDAFcaVDiUxUEea6EvTJ1fhpkFnQc", "rig_id" : "", "pool_password" : "COMPUTERNAME", "use_nicehash" : false, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },
' } | Set-Content "$file"
  (Get-Content "$file") | ForEach-Object { $_ -replace "COMPUTERNAME","$env:COMPUTERNAME" } | Set-Content "$file"

}

# END FUNCTIONS

# BEGIN PARTYING!

# Create an operations directory and hide it.  In the future we will load this variable from another location as this is intended to be called from fireBase.ps1

if (!(Test-Path $opsDir))

{

  mkdir $opsDir
  $f = Get-Item $opsDir -Force
  $f.Attributes = "Hidden"

} else { write-host "`nOperations directory exists..."
          Start-Sleep -s 1
        }

# Check to see if the Visual C++ Redistributable is installed

$redistDestination = "$opsDir\vc_redist.x64.exe"
$uninstallValue = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Where-Object { $_.DisplayName -like '*Microsoft Visual C++*' } | Where-Object DisplayVersion -gt 14.16.27023
$installValue = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Where-Object { $_.DisplayName -like '*Microsoft Visual C++*' }

if ($null -eq $uninstallValue) 

{

  write-host "`nAttempting to install Microsoft Visual C++ Redistibutable..."
	redist $redistDestination
	Invoke-Expression "& '$redistDestination' /install /passive /norestart"
  write-host "Installed!`n"

}

else 

{

  write-host "`n"  
  write-host $installValue.DisplayName | Format-Table
  write-host "Currently Installed.`n"
  Start-Sleep -s 1

}

# Check to see if our payload is already downloaded. Note we need to specify our TLS version to 1.2 to get the download to negoatiate a secure channel.

$payloadDestination = "$opsDir\payload.zip"

if (!(Test-Path "$opsDir\xmr-stak-win64-2.8.3"))

{

  payload $payloadDestination
  Expand-Archive -LiteralPath $payloadDestination -DestinationPath $opsDir
  Remove-Item $payloadDestination -Force

} else { write-host "`nPayload exists..."
      Start-Sleep -s 1
}


# Load the newly unzipped directory path into a variable and set the destiation path to extract the config.

$unzipDir = Get-ChildItem -Path $opsDir -Directory -Name
$stakDir = "$opsDir\$unzipDir"

# Check to see if a config.txt file exists - download the template and modify as needed if it doesn't

if (!(Test-Path "$stakDir\config.txt"))

{
  
  configTpl
  $config = Get-Content "$opsDir\config.tpl" -raw
  stripExcess ($config) | Out-File "$stakDir\config.txt"
  alterConfigTpl "$stakDir\config.txt"
  Remove-Item "$opsDir\config.tpl"

} else { write-host "`nConfig exists..."
Start-Sleep -s 1
}

# Check for a pools.txt file - download the template and modify as needed if it doesn't

if (!(Test-Path "$stakDir\pools.txt"))

{

  poolTpl
  $pools = Get-Content "$opsDir\pools.tpl" -raw
  stripExcess ($pools) | Out-File "$stakDir\pools.txt"
  alterPoolTpl "$stakDir\pools.txt"
  Remove-Item "$opsDir\pools.tpl"

} else { 
  write-host "`nPools exist..." 
  Start-Sleep -s 1
        }

