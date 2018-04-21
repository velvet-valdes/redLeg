Import-Module "${psscriptroot}\fireFunctions.psm1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$gridCoordinates                 = New-Object system.Windows.Forms.Form
$gridCoordinates.ClientSize      = '900,550'
$gridCoordinates.text            = "gridCoordinates"
$gridCoordinates.TopMost         = $false

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

$label_OU                        = New-Object system.Windows.Forms.Label
$label_OU.text                   = "OU="
$label_OU.AutoSize               = $true
$label_OU.width                  = 25
$label_OU.height                 = 10
$label_OU.location               = New-Object System.Drawing.Point(30,140)
$label_OU.Font                   = 'Microsoft Sans Serif,10'

$textBox_OU                      = New-Object system.Windows.Forms.TextBox
$textBox_OU.multiline            = $false
$textBox_OU.width                = 340
$textBox_OU.height               = 20
$textBox_OU.location             = New-Object System.Drawing.Point(30,170)
$textBox_OU.Font                 = 'Microsoft Sans Serif,10'

$flush                           = New-Object system.Windows.Forms.Button
$flush.text                      = "FLUSH"
$flush.width                     = 130
$flush.height                    = 65
$flush.location                  = New-Object System.Drawing.Point(30,450)
$flush.Font                      = 'Microsoft Sans Serif,10'

$write                           = New-Object system.Windows.Forms.Button
$write.text                      = "WRITE"
$write.width                     = 130
$write.height                    = 65
$write.location                  = New-Object System.Drawing.Point(241,450)
$write.Font                      = 'Microsoft Sans Serif,10'

$outputPane                      = New-Object system.Windows.Forms.Label
$outputPane.BackColor            = "#000000"
$outputPane.AutoSize             = $false
$outputPane.width                = 450
$outputPane.height               = 360
$outputPane.location             = New-Object System.Drawing.Point(400,60)
$outputPane.Font                 = 'Courier,10'
$outputPane.ForeColor            = "#7ed321"

$textBox_DC1                     = New-Object system.Windows.Forms.TextBox
$textBox_DC1.multiline           = $false
$textBox_DC1.width               = 340
$textBox_DC1.height              = 20
$textBox_DC1.location            = New-Object System.Drawing.Point(30,240)
$textBox_DC1.Font                = 'Microsoft Sans Serif,10'

$textBox_DC2                     = New-Object system.Windows.Forms.TextBox
$textBox_DC2.multiline           = $false
$textBox_DC2.width               = 340
$textBox_DC2.height              = 20
$textBox_DC2.location            = New-Object System.Drawing.Point(30,310)
$textBox_DC2.Font                = 'Microsoft Sans Serif,10'

$textBox_OpsDir                  = New-Object system.Windows.Forms.TextBox
$textBox_OpsDir.multiline        = $false
$textBox_OpsDir.width            = 340
$textBox_OpsDir.height           = 20
$textBox_OpsDir.location         = New-Object System.Drawing.Point(30,380)
$textBox_OpsDir.Font             = 'Microsoft Sans Serif,10'

$label_DC1                       = New-Object system.Windows.Forms.Label
$label_DC1.text                  = "DC="
$label_DC1.AutoSize              = $true
$label_DC1.width                 = 25
$label_DC1.height                = 10
$label_DC1.location              = New-Object System.Drawing.Point(30,210)
$label_DC1.Font                  = 'Microsoft Sans Serif,10'

$label_DC2                       = New-Object system.Windows.Forms.Label
$label_DC2.text                  = "DC="
$label_DC2.AutoSize              = $true
$label_DC2.width                 = 25
$label_DC2.height                = 10
$label_DC2.location              = New-Object System.Drawing.Point(30,280)
$label_DC2.Font                  = 'Microsoft Sans Serif,10'

$label_OpsDir                    = New-Object system.Windows.Forms.Label
$label_OpsDir.text               = "Remote Operations Path"
$label_OpsDir.AutoSize           = $true
$label_OpsDir.width              = 25
$label_OpsDir.height             = 10
$label_OpsDir.location           = New-Object System.Drawing.Point(30,350)
$label_OpsDir.Font               = 'Microsoft Sans Serif,10'

$push                            = New-Object system.Windows.Forms.Button
$push.text                       = "PUSH"
$push.width                      = 130
$push.height                     = 65
$push.location                   = New-Object System.Drawing.Point(439,451)
$push.Font                       = 'Microsoft Sans Serif,10'

$pop                             = New-Object system.Windows.Forms.Button
$pop.text                        = "POP"
$pop.width                       = 130
$pop.height                      = 65
$pop.location                    = New-Object System.Drawing.Point(641,451)
$pop.Font                        = 'Microsoft Sans Serif,10'

$gridCoordinates.controls.AddRange(@($textBox_filter,$label_filter,$label_OU,$textBox_OU,$flush,$write,$outputPane,$textBox_DC1,$textBox_DC2,$textBox_OpsDir,$label_DC1,$label_DC2,$label_OpsDir,$push,$pop))


#region gui events {
$gridCoordinates.Add_Load({ preflightCheck $outputPane; reconGrid $outputPane  })
$write.Add_Click({ setConfig $outPane $textBox_filter $textBox_OU $textBox_DC1 $textBox_DC2 $textBox_OpsDir })
#endregion events }

#endregion GUI }


#Write your logic code here

[void]$gridCoordinates.ShowDialog()