# gridCoordinates - JSON config file generator

Write-Host "gridCoordinates `n"


# test powershell version

$currentVersion = $PSVersionTable.PSVersion
if ($currentVersion -lt 5.1) 
{ 

write-host "Current Powershell Version is:" $currentVersion
write-host "Powershell Version is NO-GO AT THIS TIME!`n Please install Powershell 5.1 or greater`n" 
read-host -Prompt "Press enter to exit..."

exit 

} 

else 

{ 

write-host "Current Powershell Version is:" $currentVersion
write-host "Powershell Version is GO AT THIS TIME!`n" 

}


# Test to see if JSON configuration exists

if (Test-Path fireDirectionalControl.json)

{
    
Write-Host "Valid mission parameters exist`n Do you wish to execute missions with the current gridCoordinates or flush the current gridCoordinates ?`n"
$answer = Read-Host "`n[E]xecute`n[F]lush`n"
while("E","F" -notcontains $answer)
{
	$answer = Read-Host "`n[E]xecute`n[F]lush`n"
}

if ($answer -eq 'F') { write-host "FLUSHING MISSION PARAMETERS`n" ; Remove-Item -path fireDirectionalControl.json }
if ($answer -eq 'E') { write-host "EXCECUTE`n" ; read-host -prompt "You have chosen to retain the current mission paramters.`nPress enter to exit" ; exit }

}

else 

{ 

Write-Host "Valid mission parameters do not exist.  Enter gridCoordinates now:`n" 

}



#OU searchbase input
$searchbase = @()


#Dynamically create a menu of options, keep adding searchbases until user is done.
$searchcontinue = "null"
While ("yes","null" -contains $searchcontinue)
{
$menu = @{}
$OUhash = @{} 
$OUhash = Get-ADObject -Filter  'ObjectClass -eq "organizationalunit"’ | ? {$searchbase.name -notcontains $_.name} | select Name, DistinguishedName

Write-Host "The following are available OU's to search, and that you have not already selected." `n
for ($i=1;$i -le $OUhash.count; $i++) {
    Write-Host "$i. $($OUhash[$i-1].name)"
    $menu.Add($i,($OUhash[$i-1].name))
    }

# Ask user for first choice
[int]$ans = Read-Host `n 'Enter selection'
# Check for null or 0 value
while( $null, "0" -contains $ans)
{

[int]$ans = Read-Host `n 'Enter selection'

}
$searchbase += $OUhash[$ans-1]

Write-host `n 'You have added '-NoNewline
Write-host ($OUhash[$ans-1].name) -fore yellow -NoNewline
Write-host ' OU to the searchbase.'
Write-host `n 'Add another OU to searchbase?' -nonewline
Write-Host ' Yes or No' -ForegroundColor Yellow `n`n

$searchcontinue = Read-Host   
while("yes","no" -notcontains $searchcontinue)
{
	$searchcontinue = Read-Host "Yes or No"
}

}
# Get the needed input from the user

$filterTarget = Read-Host "Enter Cannon Filter String"
$opsDir = Read-Host "Enter REMOTE Target Operations Directory Path"
$redLeg = Read-Host "Enter LOCAL redLeg Directory Path"
Write-host "This is the searchbase:" 
$searchbase | FT -auto
write-host `n `n 

# Concatenate variables

$configPath = "$redLeg\fireDirectionalControl.json"
$advanceParty ="$redLeg\advanceParty.ps1"


# Create hashtable out of user input

$storedSettings = @{
   
    ops = $opsDir
    payload = $opsDir
    ap = $advanceParty
    target = $filterTarget
    search = $searchbase

}


# Convert hashtable to JSON and save to a file

$storedSettings | ConvertTo-Json | Out-File $configPath


# Test and give verbose feedback

If (Test-Path $configPath)

{ Write-Host "JSON configuration successfully created" } 

Else

{ Write-Host "JSON configuration FAILED" }


Read-Host -Prompt "Press Enter to exit"


exit