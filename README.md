######redLeg
The redLeg project aims to facilitate control of xmr-stak miners in an Active Directory environment.  redLeg is a reference to the Field Artillery, King of Battle.

##Getting Started
Unzip the folder to a location of your choosing.  Make note of the directory path.  You will be asked for this path when entering values for a JSON config file.

##Prerequisites
WinRM needs to be enabled on the target hosts for management purposes.  Enabling remote management for target hosts is outside the scope of this document.  Powershell 5.1 or greater is required to properly execute all cmdlets.

##Setting gridCoordinates
Before a fireMission can be executed, coordinates need to be entered.  gridCoordinates.ps1 will generate a JSON configuration file for the script to save regularly used variables.  If the configuration file is not found in the script directory, gridCoordinates will be invoked to generate a config file.

##Setting up the fireBase
Invoking fireBase.ps1 after gridCoordinates has been set will send advanceParty.ps1 to each gun in the battery, prepare the gun line and setup the fireBase.  advanceParty will set the configurations for each individual gun.

##Calling fireMission
fireMission.ps1 will fire for effect across the entire gun line until clearBreach.ps1 is called.

##Ceasfire
Invoking clearBreach.ps1 will loop through each cannon in gun line and cease firing.

##Restart the cannons
Invoking reinitGunline.ps1 loops through each cannon in the gun line and restarts the critical subsystems and power.

##Move Out
When its time to move the gun line into a new position, invoking move out will cycle through the cannons in the gun line and remove the emplaced cannons.

##Example usage
.\fireMission
.\gridCoordinates

##License
This project is licensed under the unlicense.
