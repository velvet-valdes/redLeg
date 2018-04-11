<h1>redLeg</h1>
The redLeg project aims to facilitate control of xmr-stak miners in an Active Directory environment.  redLeg is a reference to the Field Artillery, King of Battle.

<h1>Getting Started<h1>
Unzip the folder to a location of your choosing.  Make note of the directory path.

<h1>Prerequisites<h1>
WinRM needs to be enabled on the target hosts for management purposes.  Enabling remote management for target hosts is outside the scope of this document.

<h1>Setting gridCoordinates:<h1>
Before a fireMission can be executed, coordinates need to be entered.  gridCoordinates.ps1 will generate a JSON configuration file for the script to save regularly used variables.  If the configuration file is not found in the script directory, gridCoordinates will be invoked to generate a config file.

<h1>Setting up the fireBase:<h1>
Invoking fireBase.ps1 after gridCoordinates has been set will send advanceParty.ps1 to each gun in the battery, prepare the gun line and setup the fireBase.  advanceParty will set the configurations for each individual gun.

<h1>Calling fireMission:<h1>
fireMission.ps1 will fire for effect across the entire gun line until clearBreach.ps1 is called.

<h1>Ceasfire</h1>
Invoking clearBreach.ps1 will loop through each cannon in gun line and cease firing.

<h1>Restart the cannons<h1>
Invoking reinitGunline.ps1 loops through each cannon in the gun line and restarts the critical subsystems and power.

<h1>Move Out</h1>
When its time to move the gun line into a new position, invoking move out will cycle through the cannons in the gun line and remove the emplaced cannons.

Example usage
.\fireMission
.\gridCoordinates

License
This project is licensed under the unlicense.
