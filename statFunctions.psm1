# Global Varibles

$searchBase = New-Object System.Collections.Generic.List[System.Object]

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
    $outputPane.text += Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"’ | Format-Table | Out-String
  
  }
  
  function readConfig ($outputPane) {
  
    showGridCheck $outputPane
    reconGrid $outputPane
    getGrid $outputPane
  
  }
  