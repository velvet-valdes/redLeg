# gridCoordinates - JSON config file generator

Write-Host "gridCoordinates `n"


# test powershell version

$currentVersion = $PSVersionTable.PSVersion
if ($currentVersion -lt 5.1)
{

  Write-Host "Current Powershell Version is:" $currentVersion
  Write-Host "Powershell Version is NO-GO AT THIS TIME!`n Please install Powershell 5.1 or greater`n"
  Read-Host -Prompt "Press enter to exit..."

  exit

}

else

{

  Write-Host "Current Powershell Version is:" $currentVersion
  Write-Host "Powershell Version is GO AT THIS TIME!`n"

}


# Test to see if JSON configuration exists

if (Test-Path fireDirectionalControl.json)

{

  Write-Host "Valid mission parameters exist`n Do you wish to execute missions with the current gridCoordinates or flush the current gridCoordinates ?`n"
  $answer = Read-Host "`n[E]xecute`n[F]lush`n"
  while ("E","F" -notcontains $answer)
  {
    $answer = Read-Host "`n[E]xecute`n[F]lush`n"
  }

  if ($answer -eq 'F') { Write-Host "FLUSHING MISSION PARAMETERS`n"; Remove-Item -Path fireDirectionalControl.json }
  if ($answer -eq 'E') { Write-Host "EXCECUTE`n"; Read-Host -Prompt "You have chosen to retain the current mission paramters.`nPress enter to exit"; exit }

}

else

{

  Write-Host "Valid mission parameters do not exist.  Enter gridCoordinates now:`n"

}



# Create searchbase array and menu hash table

$searchbase = @()
$menu = @{}


# Add OUs to the menu hash table

$OUlist = Get-ADObject -Filter 'ObjectClass -eq "organizationalunit"’ | Select-Object Name,DistinguishedName
for ($i = 1; $i -le $OUlist.count; $i++) { $menu.Add($i,($OUlist[$i - 1].Name)) }


# Set the user input state and prompt for input

$searchcontinue = "null"
while ("yes","null" -contains $searchcontinue)

  {
 
  # Display the contents of the menu hash table

  #Clear-Host
  $menu | Format-Table -auto
  

  # Prompt for menu selection

  [int]$ans = Read-Host `n 'Enter selection'
  while ($null,"0",([int]$ans -gt ($OUlist.count))  -contains $ans) { [int]$ans = Read-Host "`n Selection out of bounds.`n Please select a number greater than 0 and less than" $OUlist.count }


  # Check to see if value has been previously selected and if not concatenate it to the searchbase
  
  if (!($searchbase.Contains($OUlist[$ans - 1]))) 
  
  { 
  
  $searchbase += $OUlist[$ans - 1] 
  Write-Host `n 'You have added ' -NoNewline
  Write-Host ($OUlist[$ans - 1].Name) -fore yellow -NoNewline
  Write-Host ' OU to the searchbase.'

  } 
  
  else 
  
  { 
  
  Write-Host `n 'Selection exists in searchbase currently' 
  
  }

  Write-Host `n 'Add another OU to searchbase?' -NoNewline
  Write-Host ' Yes or No' -ForegroundColor Yellow `n`n
  $searchcontinue = Read-Host
  while ("yes","no" -notcontains $searchcontinue)
  
  {
   
    $searchcontinue = Read-Host "Yes or No"

  }

  Clear-Host
  
  }


Write-Host "Filter and Path Parameters"
Write-Host `n`n
$filterTarget = Read-Host "Enter Cannon Filter String"
$opsDir = Read-Host "Enter REMOTE Target Operations Directory Path"
$redLeg = Read-Host "Enter LOCAL redLeg Directory Path"

# Echo final search base with some ASCII flair

Write-Host "This is the searchbase:"
$searchbase | Format-Table -auto
Write-Host "
▄▄▄  ▄▄▄ .·▄▄▄▄  ▄▄▌  ▄▄▄ . ▄▄ • 
▀▄ █·▀▄.▀·██▪ ██ ██•  ▀▄.▀·▐█ ▀ ▪
▐▀▀▄ ▐▀▀▪▄▐█· ▐█▌██▪  ▐▀▀▪▄▄█ ▀█▄
▐█•█▌▐█▄▄▌██. ██ ▐█▌▐▌▐█▄▄▌▐█▄▪▐█
.▀  ▀ ▀▀▀ ▀▀▀▀▀• .▀▀▀  ▀▀▀ ·▀▀▀▀ 
"


# Concatenate variables

$configPath = "$redLeg\fireDirectionalControl.json"
$advanceParty = "$redLeg\advanceParty.ps1"


# Create hashtable out of user input

$storedSettings = @{

  ops = $opsDir
  payload = $opsDir
  ap = $advanceParty
  Target = $filterTarget
  search = $searchbase

}


# Convert hashtable to JSON and save to a file

$storedSettings | ConvertTo-Json | Out-File $configPath


# Test and give verbose feedback

if (Test-Path $configPath) { Write-Host "JSON configuration successfully created" } else { Write-Host "JSON configuration FAILED" }
Read-Host -Prompt "Press Enter to exit"
exit