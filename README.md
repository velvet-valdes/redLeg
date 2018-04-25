# redLeg
The redLeg project aims to facilitate control of xmr-stak miners in an Active Directory environment.  redLeg is a reference to the Field Artillery, King of Battle.

## Overview
redLeg has a GUI interface which controls the underlying powershell functions.  Execute the redleg.ps1 script to launch the GUI

###### Setup 

- fireBase

###### Execute

- fireMission

###### Cease Fire

- ceaseFire

###### Remove (as needed)

- moveOut

At this time only one JSON config file is being parsed by the scripts with multiple file support intended in the future.  A JSON file is written when the 'WRITE' button is pressed regardless of whether or not variables have been initialized.  You will not be prompted to rename or move the current config - it will be overwritten!

## Installation
Unzip the folder to a location of your choosing.  Make note of the directory path.  You will be asked for this path when entering values for a JSON config file.

## Prerequisites
WinRM needs to be enabled on the target hosts for management purposes.  Enabling remote management for target hosts is outside the scope of this document.  Powershell 5.1 or greater is required to properly execute all cmdlets.

## Setting gridCoordinates
Enter the values needed in the corresponding text box fields.  Clicking the "PUSH" button will push the current values onto the stack to be written into the configuration file.  Clicking the "POP" button will pop the last value that was pushed to the stack off the stack before writing it to the configuration file.  Clicking the "CLEAR" button completely clears out any values accumulated on the stak but will not erase values already written to the JSON configuration file.

## Setting up the fireBase
Clicking the "BASE" button calls the fireBase function and begins the processes of emplacing the 'gunline'  fireBase is dependent on the advanceParty.ps1 script that is executed on remote hosts.

## Calling fireMission
Clicking the "FIRE MISSION" button sends the command for all guns in the JSON config file to fire for effect.

## Ceasfire
Clicking the "CEASE" button sends the command for all guns in the JSON config file to cease firing in parallel.

## Restart the cannons
When needed, clicking the "CYCLE" button will send the command for all guns in the JSON config file to re-initialize all critical sub-systems and power.

## Move Out
When its time to move the gun line into a new position, clicking the "OUT" button will cycle through the cannons in the gun line and remove the emplaced cannons.

## License
This project is licensed under the unlicense.
