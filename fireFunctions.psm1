# Retreive JSON Config and set Global Variables

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)


# Main Functions

function fireBase($outputPane, $progressBar) {

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

Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru
$outputPane.text = "Breaches CLEAR!"

}

function reinitGunline($outputPane, $progressBar) {

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

}

function gridCheck($outputPane) {

$searchbase = $missionParameters.search.DistinguishedName
$searchOU = $missionParameters.search.Name
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$advanceParty = $missionParameters.ap
$payload = $missionParameters.payload
$outputPane.text = "Mission Parameters:`n`nSearch Base: $searchBase`n`nSelected OU(s): $searchOU`n`nFilter Target: $filterTarget`n`nOperations Directory: $opsDir`n`nPayload Path: $payload`n`nAdvance Party: $advanceParty"

}

function moveOut($outputPane, $progressBar) {

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

function reconGrid ($outPane) {

$outPane.text += "CURRENT RECON:`n"
reconDirectory $outPane
reconBase $outPane

}

# User input functions

function setConfig ($outPane, $textBox_filter, $textBox_OU, $textBox_DC1, $textBox_DC2, $textBox_OpsDir) {


$filterTarget = $textBox_filter.text
$opsDir = $textBox_OpsDir.text
$searchBase00 = $textBox_OU.text
$searchBase01 = $textBox_DC1.text
$searchBase02 = $textBox_DC2.text
$configPath = "${psscriptroot}\fireDirectionalControl.json"
$advanceParty = "${psscriptroot}\advanceParty.ps1"
$searchBase = @("OU=$searchBase00,DC=$searchBase01,DC=$searchBase02")

# Create hashtable out of user input

$storedSettings = @{

  ops = $opsDir
  payload = $opsDir
  ap = $advanceParty
  Target = $filterTarget
  search = $searchBase

}

# Convert hashtable to JSON and save to a file

$storedSettings | ConvertTo-Json | Out-File $configPath

}

function testSet ( $outPane ) {




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