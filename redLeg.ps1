import-module activedirectory
Import-Module "${psscriptroot}\fireFunctions.psm1"
Import-Module "${psscriptroot}\asciiGraff.psm1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$redLeg = New-Object system.Windows.Forms.Form
$redLeg.ClientSize = '1200,875'
$redLeg.text = "redLeg"
$redLeg.TopMost = $false

$outputPane = New-Object system.Windows.Forms.RichTextBox
$outputPane.Multiline = $true
$outputPane.WordWrap = $false
$outputPane.EnableAutoDragDrop = $true
$outputPane.BackColor = "#000000"
$outputPane.BorderStyle = 'Fixed3D'
$outputPane.AutoSize = $false
$outputPane.width = 750
$outputPane.height = 625
$outputPane.location = New-Object System.Drawing.Point (400,40)
$outputPane.Font = 'Courier,10'
$outputPane.ForeColor = "#b8e986"

$textBox_filter = New-Object system.Windows.Forms.TextBox
$textBox_filter.Multiline = $false
$textBox_filter.width = 340
$textBox_filter.height = 20
$textBox_filter.location = New-Object System.Drawing.Point (30,60)
$textBox_filter.Font = 'Microsoft Sans Serif,10'

$label_filter = New-Object system.Windows.Forms.Label
$label_filter.text = "Active Directory Filter String"
$label_filter.AutoSize = $true
$label_filter.width = 25
$label_filter.height = 10
$label_filter.location = New-Object System.Drawing.Point (30,40)
$label_filter.Font = 'Microsoft Sans Serif,10'

$textBox_ou = New-Object system.Windows.Forms.TextBox
$textBox_ou.Multiline = $false
$textBox_ou.width = 340
$textBox_ou.height = 20
$textBox_ou.location = New-Object System.Drawing.Point (30,120)
$textBox_ou.Font = 'Microsoft Sans Serif,10'

$label_ou = New-Object system.Windows.Forms.Label
$label_ou.text = "Organizational Unit"
$label_ou.AutoSize = $true
$label_ou.width = 25
$label_ou.height = 10
$label_ou.location = New-Object System.Drawing.Point (30,100)
$label_ou.Font = 'Microsoft Sans Serif,10'

$textBox_opsDir = New-Object system.Windows.Forms.TextBox
$textBox_opsDir.Multiline = $false
$textBox_opsDir.width = 340
$textBox_opsDir.height = 20
$textBox_opsDir.location = New-Object System.Drawing.Point (30,180)
$textBox_opsDir.Font = 'Microsoft Sans Serif,10'

$label_opsDir = New-Object system.Windows.Forms.Label
$label_opsDir.text = "Remote Operations Path"
$label_opsDir.AutoSize = $true
$label_opsDir.width = 25
$label_opsDir.height = 10
$label_opsDir.location = New-Object System.Drawing.Point (30,160)
$label_opsDir.Font = 'Microsoft Sans Serif,10'

$textBox_currencyType            = New-Object system.Windows.Forms.TextBox
$textBox_currencyType.multiline  = $false
$textBox_currencyType.width      = 340
$textBox_currencyType.height     = 20
$textBox_currencyType.location   = New-Object System.Drawing.Point(30,240)
$textBox_currencyType.Font       = 'Microsoft Sans Serif,10'

$label_currencyType              = New-Object system.Windows.Forms.Label
$label_currencyType.text         = "Currency"
$label_currencyType.AutoSize     = $true
$label_currencyType.width        = 25
$label_currencyType.height       = 10
$label_currencyType.location     = New-Object System.Drawing.Point(30,220)
$label_currencyType.Font         = 'Microsoft Sans Serif,10'

$textBox_poolAddress             = New-Object system.Windows.Forms.TextBox
$textBox_poolAddress.multiline   = $false
$textBox_poolAddress.width       = 340
$textBox_poolAddress.height      = 20
$textBox_poolAddress.location    = New-Object System.Drawing.Point(30,300)
$textBox_poolAddress.Font        = 'Microsoft Sans Serif,10'

$label_poolAddress               = New-Object system.Windows.Forms.Label
$label_poolAddress.text          = "Pool Address"
$label_poolAddress.AutoSize      = $true
$label_poolAddress.width         = 25
$label_poolAddress.height        = 10
$label_poolAddress.location      = New-Object System.Drawing.Point(30,280)
$label_poolAddress.Font          = 'Microsoft Sans Serif,10'

$textBox_poolPort                = New-Object system.Windows.Forms.TextBox
$textBox_poolPort.multiline      = $false
$textBox_poolPort.width          = 340
$textBox_poolPort.height         = 20
$textBox_poolPort.location       = New-Object System.Drawing.Point(30,360)
$textBox_poolPort.Font           = 'Microsoft Sans Serif,10'

$label_poolPort                  = New-Object system.Windows.Forms.Label
$label_poolPort.text             = "Pool Port Numer"
$label_poolPort.AutoSize         = $true
$label_poolPort.width            = 25
$label_poolPort.height           = 10
$label_poolPort.location         = New-Object System.Drawing.Point(30,340)
$label_poolPort.Font             = 'Microsoft Sans Serif,10'

$textBox_walletAddress           = New-Object system.Windows.Forms.TextBox
$textBox_walletAddress.multiline  = $false
$textBox_walletAddress.width     = 340
$textBox_walletAddress.height    = 20
$textBox_walletAddress.location  = New-Object System.Drawing.Point(32,420)
$textBox_walletAddress.Font      = 'Microsoft Sans Serif,10'

$label_walletAddress             = New-Object system.Windows.Forms.Label
$label_walletAddress.text        = "Wallet Address"
$label_walletAddress.AutoSize    = $true
$label_walletAddress.width       = 25
$label_walletAddress.height      = 10
$label_walletAddress.location    = New-Object System.Drawing.Point(30,400)
$label_walletAddress.Font        = 'Microsoft Sans Serif,10'

$ammoDump = New-Object system.Windows.Forms.Button
$ammoDump.BackColor = "#f8e71c"
$ammoDump.text = "AMMO"
$ammoDump.width = 90
$ammoDump.height = 90
$ammoDump.location = New-Object System.Drawing.Point (30,465)
$ammoDump.Font = 'Microsoft Sans Serif,10'

$fireBase = New-Object system.Windows.Forms.Button
$fireBase.BackColor = "#f8e71c"
$fireBase.text = "BASE"
$fireBase.width = 90
$fireBase.height = 90
$fireBase.location = New-Object System.Drawing.Point (155,465)
$fireBase.Font = 'Microsoft Sans Serif,10'

$ceaseFire = New-Object system.Windows.Forms.Button
$ceaseFire.BackColor = "#d0021b"
$ceaseFire.text = "CEASE"
$ceaseFire.width = 90
$ceaseFire.height = 90
$ceaseFire.location = New-Object System.Drawing.Point (280,465)
$ceaseFire.Font = 'Microsoft Sans Serif,10'

$fireMission = New-Object system.Windows.Forms.Button
$fireMission.BackColor = "#7ed321"
$fireMission.text = "FIRE"
$fireMission.width = 90
$fireMission.height = 90
$fireMission.location = New-Object System.Drawing.Point (34,575)
$fireMission.Font = 'Microsoft Sans Serif,10'

$cycleGunline = New-Object system.Windows.Forms.Button
$cycleGunline.BackColor = "#f8e71c"
$cycleGunline.text = "CYCLE"
$cycleGunline.width = 90
$cycleGunline.height = 90
$cycleGunline.location = New-Object System.Drawing.Point (155,575)
$cycleGunline.Font = 'Microsoft Sans Serif,10'

$moveOut = New-Object system.Windows.Forms.Button
$moveOut.BackColor = "#f8e71c"
$moveOut.text = "OUT"
$moveOut.width = 90
$moveOut.height = 90
$moveOut.location = New-Object System.Drawing.Point (280,575)
$moveOut.Font = 'Microsoft Sans Serif,10'

$progressBar = New-Object system.Windows.Forms.ProgressBar
$progressBar.width = 1120
$progressBar.height = 25
$progressBar.location = New-Object System.Drawing.Point (35,715)

$readConfig = New-Object system.Windows.Forms.Button
$readConfig.BackColor = "#f8e71c"
$readConfig.text = "READ"
$readConfig.width = 150
$readConfig.height = 65
$readConfig.location = New-Object System.Drawing.Point (34,775)
$readConfig.Font = 'Microsoft Sans Serif,10'

$writeConfig = New-Object system.Windows.Forms.Button
$writeConfig.BackColor = "#f8e71c"
$writeConfig.text = "WRITE"
$writeConfig.width = 150
$writeConfig.height = 65
$writeConfig.location = New-Object System.Drawing.Point (280,775)
$writeConfig.Font = 'Microsoft Sans Serif,10'

$push = New-Object system.Windows.Forms.Button
$push.BackColor = "#f8e71c"
$push.text = "PUSH"
$push.width = 150
$push.height = 65
$push.location = New-Object System.Drawing.Point (520,775)
$push.Font = 'Microsoft Sans Serif,10'

$pop = New-Object system.Windows.Forms.Button
$pop.BackColor = "#f8e71c"
$pop.text = "POP"
$pop.width = 150
$pop.height = 65
$pop.location = New-Object System.Drawing.Point (770,775)
$pop.Font = 'Microsoft Sans Serif,10'

$clear = New-Object system.Windows.Forms.Button
$clear.BackColor = "#f8e71c"
$clear.text = "CLEAR"
$clear.width = 150
$clear.height = 65
$clear.location = New-Object System.Drawing.Point (1000,775)
$clear.Font = 'Microsoft Sans Serif,10'

$redLeg.controls.AddRange(@($outputPane, $textBox_filter, $label_filter, $textBox_ou, $label_ou, $textBox_opsDir, $label_opsDir, $textBox_currencyType, $label_currencyType, $textBox_poolAddress, $label_poolAddress, $textBox_poolPort, $label_poolPort, $textBox_walletAddress, $label_walletAddress, $ammoDump, $fireBase, $ceaseFire, $fireMission, $cycleGunline, $moveOut, $progressBar, $readConfig, $writeConfig, $push, $pop, $clear))
# GUI Events

$redLeg.Add_Load({ showRedLeg $outputPane; preflightCheck $outputPane; reconGrid $outputPane; })
$writeConfig.Add_Click({ setGrid $outputPane $textBox_filter $textBox_opsDir })
$readConfig.Add_Click({ readConfig $outputPane })
$push.Add_Click({ pushGrid $outputPane $textBox_ou })
$pop.Add_Click({ popGrid $outputPane $textBox_ou })
$clear.Add_Click({ clearGrid $outputPane $progressBar })
$fireBase.Add_Click({ fireBase $outputPane $progressBar })
$ceaseFire.Add_Click({ ceaseFire $outputPane $progressBar })
$fireMission.Add_Click({ fireMission $outputPane $progressBar })
$cycleGunline.Add_Click({ cycleGunline $outputPane $progressBar })
$moveOut.Add_Click({ moveOut $outputPane $progressBar })
$ammoDump.Add_Click({ ammoDump $outputPane $progressBar })

# Display the Form

[void]$redLeg.ShowDialog()
