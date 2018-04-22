Import-Module "${psscriptroot}\fireFunctions.psm1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$gridCoordinates                 = New-Object system.Windows.Forms.Form
$gridCoordinates.ClientSize      = '900,550'
$gridCoordinates.text            = "gridCoordinates"
$gridCoordinates.TopMost         = $false

$outputPane                      = New-Object system.Windows.Forms.TextBox
$outputPane.Multiline            = $true
$outputPane.BackColor            = "#000000"
$outputPane.BorderStyle          = 'Fixed3D'
$outputPane.AutoSize             = $false
$outputPane.width                = 450
$outputPane.height               = 360
$outputPane.location             = New-Object System.Drawing.Point(400,50)
$outputPane.Font                 = 'Courier,10'
$outputPane.ForeColor            = "#7ed321"

$textBox_OpsDir                  = New-Object system.Windows.Forms.TextBox
$textBox_OpsDir.multiline        = $false
$textBox_OpsDir.width            = 340
$textBox_OpsDir.height           = 20
$textBox_OpsDir.location         = New-Object System.Drawing.Point(30,240)
$textBox_OpsDir.Font             = 'Microsoft Sans Serif,10'

$label_OpsDir                    = New-Object system.Windows.Forms.Label
$label_OpsDir.text               = "Remote Operations Path"
$label_OpsDir.AutoSize           = $true
$label_OpsDir.width              = 25
$label_OpsDir.height             = 10
$label_OpsDir.location           = New-Object System.Drawing.Point(30,210)
$label_OpsDir.Font               = 'Microsoft Sans Serif,10'

$textBox_OU                      = New-Object system.Windows.Forms.TextBox
$textBox_OU.multiline            = $false
$textBox_OU.width                = 340
$textBox_OU.height               = 20
$textBox_OU.location             = New-Object System.Drawing.Point(30,170)
$textBox_OU.Font                 = 'Microsoft Sans Serif,10'

$label_OU                        = New-Object system.Windows.Forms.Label
$label_OU.text                   = "Organizational Unit"
$label_OU.AutoSize               = $true
$label_OU.width                  = 25
$label_OU.height                 = 10
$label_OU.location               = New-Object System.Drawing.Point(30,140)
$label_OU.Font                   = 'Microsoft Sans Serif,10'

$textBox_filter                  = New-Object system.Windows.Forms.TextBox
$textBox_filter.multiline        = $false
$textBox_filter.width            = 340
$textBox_filter.height           = 20
$textBox_filter.location         = New-Object System.Drawing.Point(30,100)
$textBox_filter.Font             = 'Microsoft Sans Serif,10'

$label_filter                    = New-Object system.Windows.Forms.Label
$label_filter.text               = "Active Directory Filter String"
$label_filter.AutoSize           = $true
$label_filter.width              = 25
$label_filter.height             = 10
$label_filter.location           = New-Object System.Drawing.Point(30,70)
$label_filter.Font               = 'Microsoft Sans Serif,10'

$readConfig                      = New-Object system.Windows.Forms.Button
$readConfig.text                 = "READ CONFIG"
$readConfig.width                = 130
$readConfig.height               = 65
$readConfig.location             = New-Object System.Drawing.Point(30,450)
$readConfig.Font                 = 'Microsoft Sans Serif,10'

$writeConfig                     = New-Object system.Windows.Forms.Button
$writeConfig.text                = "WRITE CONFIG"
$writeConfig.width               = 130
$writeConfig.height              = 65
$writeConfig.location            = New-Object System.Drawing.Point(240,450)
$writeConfig.Font                = 'Microsoft Sans Serif,10'

$push                            = New-Object system.Windows.Forms.Button
$push.text                       = "PUSH"
$push.width                      = 130
$push.height                     = 65
$push.location                   = New-Object System.Drawing.Point(400,450)
$push.Font                       = 'Microsoft Sans Serif,10'

$pop                             = New-Object system.Windows.Forms.Button
$pop.text                        = "POP"
$pop.width                       = 130
$pop.height                      = 65
$pop.location                    = New-Object System.Drawing.Point(560,450)
$pop.Font                        = 'Microsoft Sans Serif,10'

$clear                           = New-Object system.Windows.Forms.Button
$clear.text                      = "CLEAR"
$clear.width                     = 130
$clear.height                    = 65
$clear.location                  = New-Object System.Drawing.Point(720,450)
$clear.Font                      = 'Microsoft Sans Serif,10'

$gridCoordinates.controls.AddRange(@($outputPane,$textBox_OpsDir,$label_OpsDir,$textBox_OU,$label_OU,$textBox_filter,$label_filter,$readConfig,$writeConfig,$push,$pop,$clear))


#region gui events {
$gridCoordinates.Add_Load({ showRedleg $outputPane ; preflightCheck $outputPane; reconGrid $outputPane  })
$writeConfig.Add_Click({ setGrid $outputPane $textBox_filter $textBox_OpsDir })
$readConfig.Add_Click({ getGrid $outputPane })
$push.Add_Click({ pushGrid $outputPane $textBox_OU })
$pop.Add_Click({ popGrid $outputPane $textBox_OU })
$clear.Add_Click({ clearGrid $outputPane })
#endregion events }

#endregion GUI }

[void]$gridCoordinates.ShowDialog()