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
$textBox_filter.location         = New-Object System.Drawing.Point(30,60)
$textBox_filter.Font             = 'Microsoft Sans Serif,10'

$label_filter                    = New-Object system.Windows.Forms.Label
$label_filter.text               = "Active Directory Filter String"
$label_filter.AutoSize           = $true
$label_filter.width              = 25
$label_filter.height             = 10
$label_filter.location           = New-Object System.Drawing.Point(30,30)
$label_filter.Font               = 'Microsoft Sans Serif,10'

$textBox_SearchBase              = New-Object system.Windows.Forms.TextBox
$textBox_SearchBase.multiline    = $false
$textBox_SearchBase.width        = 340
$textBox_SearchBase.height       = 20
$textBox_SearchBase.location     = New-Object System.Drawing.Point(30,130)
$textBox_SearchBase.Font         = 'Microsoft Sans Serif,10'

$label_SearchBase                = New-Object system.Windows.Forms.Label
$label_SearchBase.text           = "Active Directory Search Base OU"
$label_SearchBase.AutoSize       = $true
$label_SearchBase.width          = 25
$label_SearchBase.height         = 10
$label_SearchBase.location       = New-Object System.Drawing.Point(30,100)
$label_SearchBase.Font           = 'Microsoft Sans Serif,10'

$label_OpsDir                    = New-Object system.Windows.Forms.Label
$label_OpsDir.text               = "Remote Operations Path"
$label_OpsDir.AutoSize           = $true
$label_OpsDir.width              = 25
$label_OpsDir.height             = 10
$label_OpsDir.location           = New-Object System.Drawing.Point(30,170)
$label_OpsDir.Font               = 'Microsoft Sans Serif,10'

$textBox_OpsDir                  = New-Object system.Windows.Forms.TextBox
$textBox_OpsDir.multiline        = $false
$textBox_OpsDir.width            = 340
$textBox_OpsDir.height           = 20
$textBox_OpsDir.location         = New-Object System.Drawing.Point(30,200)
$textBox_OpsDir.Font             = 'Microsoft Sans Serif,10'

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
$write.location                  = New-Object System.Drawing.Point(240,450)
$write.Font                      = 'Microsoft Sans Serif,10'

$outputPane                      = New-Object system.Windows.Forms.Label
$outputPane.BackColor            = "#000000"
$outputPane.AutoSize             = $false
$outputPane.width                = 450
$outputPane.height               = 360
$outputPane.location             = New-Object System.Drawing.Point(400,60)
$outputPane.Font                 = 'Courier,10'
$outputPane.ForeColor            = "#7ed321"

$gridCoordinates.controls.AddRange(@($textBox_filter,$label_filter,$textBox_SearchBase,$label_SearchBase,$label_OpsDir,$textBox_OpsDir,$flush,$write,$outputPane))

#region gui events {
$gridCoordinates.Add_Load({ preflightCheck $outputPane })
$write.Add_Click({ setConfig $outPane $textBox_filter $textBox_SearchBase $textBox_OpsDir})
#endregion events }

#endregion GUI }


#Write your logic code here

[void]$gridCoordinates.ShowDialog()