Import-Module "${psscriptroot}\fireFunctions.psm1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$redLeg                          = New-Object system.Windows.Forms.Form
$redLeg.ClientSize               = '600,400'
$redLeg.text                     = "redLeg - fireDirectionalControl"
$redLeg.TopMost                  = $false
#$redLegImage                     = [system.drawing.image]::FromFile("${psscriptroot}\crossCannons.png")
#$redLeg.BackgroundImage          = $redLegImage
#$redLeg.BackgroundImageLayout    = "Zoom"

$outputPane                      = New-Object system.Windows.Forms.Label
$outputPane.BackColor            = "#000000"
$outputPane.BorderStyle          = 'Fixed3D'
$outputPane.width                = 380
$outputPane.height               = 270
$outputPane.location             = New-Object System.Drawing.Point(170,45)
$outputPane.Font                 = 'Courier,10'
$outputPane.ForeColor            = "#7ed321"

$fireMission                     = New-Object system.Windows.Forms.Button
$fireMission.text                = "FIRE MISSION"
$fireMission.width               = 90
$fireMission.height              = 30
$fireMission.location            = New-Object System.Drawing.Point(40,90)
$fireMission.Font                = 'Microsoft Sans Serif,8'

$fireBase                        = New-Object system.Windows.Forms.Button
$fireBase.text                   = "FIRE BASE"
$fireBase.width                  = 90
$fireBase.height                 = 30
$fireBase.location               = New-Object System.Drawing.Point(40,40)
$fireBase.Font                   = 'Microsoft Sans Serif,8'

$clearBreach                     = New-Object system.Windows.Forms.Button
$clearBreach.text                = "CEASE FIRE"
$clearBreach.width               = 90
$clearBreach.height              = 30
$clearBreach.location            = New-Object System.Drawing.Point(40,140)
$clearBreach.Font                = 'Microsoft Sans Serif,8'

$moveOut                         = New-Object system.Windows.Forms.Button
$moveOut.text                    = "MOVE OUT"
$moveOut.width                   = 90
$moveOut.height                  = 30
$moveOut.location                = New-Object System.Drawing.Point(40,290)
$moveOut.Font                    = 'Microsoft Sans Serif,8'

$progressBar                     = New-Object system.Windows.Forms.ProgressBar
$progressBar.width               = 515
$progressBar.height              = 20
$progressBar.location            = New-Object System.Drawing.Point(49,351)

$reinitGunline                   = New-Object system.Windows.Forms.Button
$reinitGunline.text              = "INITALIZE"
$reinitGunline.width             = 90
$reinitGunline.height            = 30
$reinitGunline.location          = New-Object System.Drawing.Point(40,190)
$reinitGunline.Font              = 'Microsoft Sans Serif,8'

$gridCheck                       = New-Object system.Windows.Forms.Button
$gridCheck.text                  = "CHECK"
$gridCheck.width                 = 90
$gridCheck.height                = 30
$gridCheck.location              = New-Object System.Drawing.Point(40,240)
$gridCheck.Font                  = 'Microsoft Sans Serif,8'



$redLeg.controls.AddRange(@($fireMission,$fireBase,$clearBreach,$moveOut,$progressBar,$reinitGunline,$gridCheck,$outputPane))

#region gui events {
$fireBase.Add_Click({ fireBase $outputPane $progressBar })
$fireMission.Add_Click({ fireMission $outputPane $progressBar })
$clearBreach.Add_Click({ clearBreach $outputPane $progressBar })
$reinitGunline.Add_Click({ reinitGunline $outputPane $progressBar })
$moveOut.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Breaking Down The Firebase`nMoving Out..." , "Confirm Entry") ; moveOut $outputPane $progressBar })
$gridCheck.Add_Click({ getGrid $outputPane })
#$fireBase.Add_MouseEnter({ showFireBase $outputPane })
#$fireMission.Add_MouseEnter({ showFireMission $outputPane })
#$clearBreach.Add_MouseEnter({ showClearBreach $outputPane })
#$reinitGunline.Add_MouseEnter({ showReinitGunline $outputPane })
#$gridCheck.Add_MouseEnter({ showGridCheck $outputPane })
#$moveOut.Add_MouseEnter({ showMoveOut $outputPane })
#endregion events }

#endregion GUI }

[void]$redLeg.ShowDialog()