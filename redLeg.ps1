Import-Module "${psscriptroot}\fireFunctions.psm1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$redLeg = New-Object system.Windows.Forms.Form
$redLeg.ClientSize = '1200,675'
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
$outputPane.height = 450
$outputPane.location = New-Object System.Drawing.Point (400,40)
$outputPane.Font = 'Courier,10'
$outputPane.ForeColor = "#b8e986"

$textBox_OpsDir = New-Object system.Windows.Forms.TextBox
$textBox_OpsDir.Multiline = $false
$textBox_OpsDir.width = 340
$textBox_OpsDir.height = 20
$textBox_OpsDir.location = New-Object System.Drawing.Point (30,240)
$textBox_OpsDir.Font = 'Microsoft Sans Serif,10'

$label_OpsDir = New-Object system.Windows.Forms.Label
$label_OpsDir.text = "Remote Operations Path"
$label_OpsDir.AutoSize = $true
$label_OpsDir.width = 25
$label_OpsDir.height = 10
$label_OpsDir.location = New-Object System.Drawing.Point (30,210)
$label_OpsDir.Font = 'Microsoft Sans Serif,10'

$textBox_OU = New-Object system.Windows.Forms.TextBox
$textBox_OU.Multiline = $false
$textBox_OU.width = 340
$textBox_OU.height = 20
$textBox_OU.location = New-Object System.Drawing.Point (30,170)
$textBox_OU.Font = 'Microsoft Sans Serif,10'

$label_OU = New-Object system.Windows.Forms.Label
$label_OU.text = "Organizational Unit"
$label_OU.AutoSize = $true
$label_OU.width = 25
$label_OU.height = 10
$label_OU.location = New-Object System.Drawing.Point (30,140)
$label_OU.Font = 'Microsoft Sans Serif,10'

$textBox_filter = New-Object system.Windows.Forms.TextBox
$textBox_filter.Multiline = $false
$textBox_filter.width = 340
$textBox_filter.height = 20
$textBox_filter.location = New-Object System.Drawing.Point (30,100)
$textBox_filter.Font = 'Microsoft Sans Serif,10'

$label_filter = New-Object system.Windows.Forms.Label
$label_filter.text = "Active Directory Filter String"
$label_filter.AutoSize = $true
$label_filter.width = 25
$label_filter.height = 10
$label_filter.location = New-Object System.Drawing.Point (30,70)
$label_filter.Font = 'Microsoft Sans Serif,10'

$readConfig = New-Object system.Windows.Forms.Button
$readConfig.text = "READ"
$readConfig.width = 150
$readConfig.height = 65
$readConfig.location = New-Object System.Drawing.Point (34,530)
$readConfig.Font = 'Microsoft Sans Serif,10'

$writeConfig = New-Object system.Windows.Forms.Button
$writeConfig.text = "WRITE"
$writeConfig.width = 150
$writeConfig.height = 65
$writeConfig.location = New-Object System.Drawing.Point (280,530)
$writeConfig.Font = 'Microsoft Sans Serif,10'

$push = New-Object system.Windows.Forms.Button
$push.text = "PUSH"
$push.width = 150
$push.height = 65
$push.location = New-Object System.Drawing.Point (520,529)
$push.Font = 'Microsoft Sans Serif,10'

$pop = New-Object system.Windows.Forms.Button
$pop.text = "POP"
$pop.width = 150
$pop.height = 65
$pop.location = New-Object System.Drawing.Point (770,529)
$pop.Font = 'Microsoft Sans Serif,10'

$clear = New-Object system.Windows.Forms.Button
$clear.text = "CLEAR"
$clear.width = 150
$clear.height = 65
$clear.location = New-Object System.Drawing.Point (1000,530)
$clear.Font = 'Microsoft Sans Serif,10'

$fireBase = New-Object system.Windows.Forms.Button
$fireBase.text = "BASE"
$fireBase.width = 90
$fireBase.height = 90
$fireBase.location = New-Object System.Drawing.Point (155,290)
$fireBase.Font = 'Microsoft Sans Serif,10'

$ceaseFire = New-Object system.Windows.Forms.Button
$ceaseFire.text = "CEASE"
$ceaseFire.width = 90
$ceaseFire.height = 90
$ceaseFire.location = New-Object System.Drawing.Point (280,290)
$ceaseFire.Font = 'Microsoft Sans Serif,10'

$fireMission = New-Object system.Windows.Forms.Button
$fireMission.text = "FIRE"
$fireMission.width = 90
$fireMission.height = 90
$fireMission.location = New-Object System.Drawing.Point (30,400)
$fireMission.Font = 'Microsoft Sans Serif,10'

$cycleGunline = New-Object system.Windows.Forms.Button
$cycleGunline.text = "CYCLE"
$cycleGunline.width = 90
$cycleGunline.height = 90
$cycleGunline.location = New-Object System.Drawing.Point (155,400)
$cycleGunline.Font = 'Microsoft Sans Serif,10'

$moveOut = New-Object system.Windows.Forms.Button
$moveOut.text = "OUT"
$moveOut.width = 90
$moveOut.height = 90
$moveOut.location = New-Object System.Drawing.Point (280,400)
$moveOut.Font = 'Microsoft Sans Serif,10'

$progressBar = New-Object system.Windows.Forms.ProgressBar
$progressBar.width = 1120
$progressBar.height = 20
$progressBar.location = New-Object System.Drawing.Point (35,624)

$ammoDump = New-Object system.Windows.Forms.Button
$ammoDump.text = "AMMO"
$ammoDump.width = 90
$ammoDump.height = 90
$ammoDump.location = New-Object System.Drawing.Point (30,290)
$ammoDump.Font = 'Microsoft Sans Serif,10'

$redLeg.controls.AddRange(@($outputPane,$textBox_OpsDir,$label_OpsDir,$textBox_OU,$label_OU,$textBox_filter,$label_filter,$readConfig,$writeConfig,$push,$pop,$clear,$fireBase,$ceaseFire,$fireMission,$cycleGunline,$moveOut,$progressBar,$ammoDump))

# GUI Events

$redLeg.Add_Load({ showRedLeg $outputPane; preflightCheck $outputPane; reconGrid $outputPane; })
$writeConfig.Add_Click({ setGrid $outputPane $textBox_filter $textBox_OpsDir })
$readConfig.Add_Click({ readConfig $outputPane })
$push.Add_Click({ pushGrid $outputPane $textBox_OU })
$pop.Add_Click({ popGrid $outputPane $textBox_OU })
$clear.Add_Click({ clearGrid $outputPane $progressBar })
$fireBase.Add_Click({ fireBase $outputPane $progressBar })
$ceaseFire.Add_Click({ ceaseFire $outputPane $progressBar })
$fireMission.Add_Click({ fireMission $outputPane $progressBar })
$cycleGunline.Add_Click({ cycleGunline $outputPane $progressBar })
$moveOut.Add_Click({ moveOut $outputPane $progressBar })
$ammoDump.Add_Click({ ammoDump $outputPane $progressBar })

# Display the Form

[void]$redLeg.ShowDialog()
