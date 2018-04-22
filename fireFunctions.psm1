# Global Varibles

$searchBase = New-Object System.Collections.Generic.List[System.Object]

# Main Functions

function fireBase($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$opsDir = $missionParameters.ops
$filterTarget = $missionParameters.Target
$advanceParty = $missionParameters.ap
$searchbase = $missionParameters.search
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$cmdstring = "invoke-command -computername $client -FilePath $advanceParty"
$scriptblock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-noexit -command $Scriptblock"

}
}

function fireMission($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client ; & ‘$opsDir\xmr-stak-win64\xmr-stak.exe’ -c '$opsDir\xmr-stak-win64\config.txt' -C '$opsDir\xmr-stak-win64\pools.txt'}"
$scriptblock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-noexit -command  $Scriptblock"

}
}

function clearBreach($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
Invoke-Command -ComputerName $client -ScriptBlock { Stop-Process -Name xmr-stak }
$outputPane.text = "$client - Clearing Breach..."

}

} # rename - ceaseFire

function reinitGunline($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$filterTarget = $missionParameters.Target
$searchbase = $missionParameters.search
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$outputPane.Text = "Sending command to $client..."
Restart-Computer -ComputerName $client -Force

}

Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru

} # rename - cycleGunline

function getGrid($outputPane) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search.DistinguishedName
$searchOU = $missionParameters.search.Name
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$advanceParty = $missionParameters.ap
$payload = $missionParameters.payload
$outputPane.text = "Mission Parameters:`n`nSearch Base: $searchBase`n`nSelected OU(s): $searchOU`n`nFilter Target: $filterTarget`n`nOperations Directory: $opsDir`n`nPayload Path: $payload`n`nAdvance Party: $advanceParty"

} #renamed from gridCheck

function pushGrid($outputPane, $textBox_OU) {

[string]$searchString = $textBox_OU.text
$selection = Get-ADObject -Filter "Name -eq '$searchString'" | select Name, DistinguishedName
if (!($searchBase -match $selection)) { $searchBase.Add($selection) }
write-host $searchBase.ToArray()
$outputPane.text = "Current Search Base:`n" 
$outputPane.text += $searchBase.name

 }

 function popGrid($outputPane, $textBox_OU) {

 }

function setGrid ($outputPane, $textBox_filter, $textBox_OpsDir) {

$filterTarget = $textBox_filter.text
$opsDir = $textBox_OpsDir.text
$configPath = "${psscriptroot}\fireDirectionalControl.json"
$advanceParty = "${psscriptroot}\advanceParty.ps1"
$storedSettings = @{

  ops = $opsDir
  payload = $opsDir
  ap = $advanceParty
  Target = $filterTarget
  search = $searchBase

}
$storedSettings | ConvertTo-Json | Out-File $configPath

}

function moveOut($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$cmdstring = “invoke-command -computername $client -scriptblock { If(test-path $opsDir) { write-host $client ‘Operations Directory = REMOVED’ ; Remove-Item -path $opsDir -Recurse -Force } Else { write-host 'Operations Directory = NON-EXISTANT' }}”
$scriptblock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-noexit -command $Scriptblock"

}
}

# Info functions

function versionCheck($outputPane) {

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

function jsonCheck($outputPane) {

if (Test-Path "${psscriptroot}\fireDirectionalControl.json")

{

  $outputPane.text += "Config File Present`n`n"
  
}

else

{

  $outputPane.text += "Config File Needed`n`n"

}

}

function preflightCheck($outputPane) {

versionCheck $outputPane
jsonCheck $outputPane

}

function clearShells ($outputPane) { 

Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru

}

# Active Directory functions

function reconDirectory ($outputPane) {

$searchbase = @()
$menu = @{}
$OUlist = Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"’ | Select-Object Name,DistinguishedName
for ($i = 1; $i -le $OUlist.count; $i++) { $menu.Add($i,($OUlist[$i - 1].Name)) }
$outputPane.text += "`nOrganizational Units:`n"

for ($x = 1; $x -le $menu.count; $x++) { 

$outputPane.text += ($menu.Item($x), "`n")

}

}

function reconBase ($outputPane) {

$searchbase = @()
$menu = @{}
$OUlist = Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"’ | Select-Object Name,DistinguishedName
for ($i = 1; $i -le $OUlist.count; $i++) { $menu.Add($i,($OUlist[$i - 1].DistinguishedName)) }
$outputPane.text += "`nSearchbase Candidates:`n"

for ($x = 1; $x -le $menu.count; $x++) { 

$outputPane.text += ($menu.Item($x), "`n")

}

}

function reconGrid ($outputPane) {

$outputPane.text += "CURRENT RECON:`n"
reconDirectory $outputPane
reconBase $outputPane

}

# Sick ASCII art functions

function showFireBase($outputPane) { 

$logoASCIIfireBase = "
·▄▄▄▪  ▄▄▄  ▄▄▄ .      
▐▄▄·██ ▀▄ █·▀▄.▀·      
██▪ ▐█·▐▀▀▄ ▐▀▀▪▄      
██▌.▐█▌▐█•█▌▐█▄▄▌      
▀▀▀ ▀▀▀.▀  ▀ ▀▀▀       
▄▄▄▄·  ▄▄▄· .▄▄ · ▄▄▄ .
▐█ ▀█▪▐█ ▀█ ▐█ ▀. ▀▄.▀·
▐█▀▀█▄▄█▀▀█ ▄▀▀▀█▄▐▀▀▪▄
██▄▪▐█▐█ ▪▐▌▐█▄▪▐█▐█▄▄▌
·▀▀▀▀  ▀  ▀  ▀▀▀▀  ▀▀▀ 
"
$outputPane.text = $logoASCIIfireBase 

}

function showFireMission($outputPane) { 

$logoASCIIfireMission = "
·▄▄▄▪  ▄▄▄  ▄▄▄ .                     
▐▄▄·██ ▀▄ █·▀▄.▀·                     
██▪ ▐█·▐▀▀▄ ▐▀▀▪▄                     
██▌.▐█▌▐█•█▌▐█▄▄▌                     
▀▀▀ ▀▀▀.▀  ▀ ▀▀▀                      
• ▌ ▄ ·. ▪  .▄▄ · .▄▄ · ▪         ▐ ▄ 
·██ ▐███▪██ ▐█ ▀. ▐█ ▀. ██ ▪     •█▌▐█
▐█ ▌▐▌▐█·▐█·▄▀▀▀█▄▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌
██ ██▌▐█▌▐█▌▐█▄▪▐█▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌
▀▀  █▪▀▀▀▀▀▀ ▀▀▀▀  ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪
"
$outputPane.text = $logoASCIIfireMission 

}

function showClearBreach($outputPane) { 

$logoASCIIclearBreach = "
 ▄▄· ▄▄▌  ▄▄▄ . ▄▄▄· ▄▄▄        
▐█ ▌▪██•  ▀▄.▀·▐█ ▀█ ▀▄ █·      
██ ▄▄██▪  ▐▀▀▪▄▄█▀▀█ ▐▀▀▄       
▐███▌▐█▌▐▌▐█▄▄▌▐█ ▪▐▌▐█•█▌      
·▀▀▀ .▀▀▀  ▀▀▀  ▀  ▀ .▀  ▀      
▄▄▄▄· ▄▄▄  ▄▄▄ . ▄▄▄·  ▄▄·  ▄ .▄
▐█ ▀█▪▀▄ █·▀▄.▀·▐█ ▀█ ▐█ ▌▪██▪▐█
▐█▀▀█▄▐▀▀▄ ▐▀▀▪▄▄█▀▀█ ██ ▄▄██▀▐█
██▄▪▐█▐█•█▌▐█▄▄▌▐█ ▪▐▌▐███▌██▌▐▀
·▀▀▀▀ .▀  ▀ ▀▀▀  ▀  ▀ ·▀▀▀ ▀▀▀ ·
"
$outputPane.text = $logoASCIIclearBreach 

}

function showReinitGunline($outputPane) { 

$logoASCIIreinitGunline = "
▄▄▄  ▄▄▄ .▪   ▐ ▄ ▪  ▄▄▄▄▄        
▀▄ █·▀▄.▀·██ •█▌▐███ •██          
▐▀▀▄ ▐▀▀▪▄▐█·▐█▐▐▌▐█· ▐█.▪        
▐█•█▌▐█▄▄▌▐█▌██▐█▌▐█▌ ▐█▌·        
.▀  ▀ ▀▀▀ ▀▀▀▀▀ █▪▀▀▀ ▀▀▀         
 ▄▄ • ▄• ▄▌ ▐ ▄ ▄▄▌  ▪   ▐ ▄ ▄▄▄ .
▐█ ▀ ▪█▪██▌•█▌▐███•  ██ •█▌▐█▀▄.▀·
▄█ ▀█▄█▌▐█▌▐█▐▐▌██▪  ▐█·▐█▐▐▌▐▀▀▪▄
▐█▄▪▐█▐█▄█▌██▐█▌▐█▌▐▌▐█▌██▐█▌▐█▄▄▌
·▀▀▀▀  ▀▀▀ ▀▀ █▪.▀▀▀ ▀▀▀▀▀ █▪ ▀▀▀ 
"
$outputPane.text = $logoASCIIreinitGunline 

}

function showGridCheck($outputPane){ 

$logoASCIIgridCheck = "
 ▄▄ • ▄▄▄  ▪  ·▄▄▄▄      
▐█ ▀ ▪▀▄ █·██ ██▪ ██     
▄█ ▀█▄▐▀▀▄ ▐█·▐█· ▐█▌    
▐█▄▪▐█▐█•█▌▐█▌██. ██     
·▀▀▀▀ .▀  ▀▀▀▀▀▀▀▀▀•     
 ▄▄·  ▄ .▄▄▄▄ . ▄▄· ▄ •▄ 
▐█ ▌▪██▪▐█▀▄.▀·▐█ ▌▪█▌▄▌▪
██ ▄▄██▀▐█▐▀▀▪▄██ ▄▄▐▀▀▄·
▐███▌██▌▐▀▐█▄▄▌▐███▌▐█.█▌
·▀▀▀ ▀▀▀ · ▀▀▀ ·▀▀▀ ·▀  ▀
"
$outputPane.text = $logoASCIIgridCheck 

}

function showMoveOut($outputPane) { 

$logoASCIImoveOut = "
• ▌ ▄ ·.        ▌ ▐·▄▄▄ .      ▄• ▄▌▄▄▄▄▄
·██ ▐███▪▪     ▪█·█▌▀▄.▀·▪     █▪██▌•██  
▐█ ▌▐▌▐█· ▄█▀▄ ▐█▐█•▐▀▀▪▄ ▄█▀▄ █▌▐█▌ ▐█.▪
██ ██▌▐█▌▐█▌.▐▌ ███ ▐█▄▄▌▐█▌.▐▌▐█▄█▌ ▐█▌·
▀▀  █▪▀▀▀ ▀█▄▀▪. ▀   ▀▀▀  ▀█▄▀▪ ▀▀▀  ▀▀▀ 
"
$outputPane.text = $logoASCIImoveOut 

}

function showRedLeg($outputPane) { 

$logoASCIIredLeg = "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
$outputPane.text = $logoASCIIredLeg

}