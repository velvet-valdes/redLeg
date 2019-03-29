# redLeg
The redLeg project aims to facilitate control of xmr-stak miners in an Active Directory environment.  redLeg is a reference to the Field Artillery, King of Battle.

## Overview
redLeg has a GUI interface which controls the underlying powershell functions.  Execute the redleg.ps1 script to launch the GUI

###### Setup 

- ammoDump 
- fireBase

###### Execute

- fireMission

###### Cease Fire

- ceaseFire

###### Remove (as needed)

- moveOut

At this time only one JSON config file is being parsed by the scripts with multiple file support intended in the future.  A JSON file is written when the 'WRITE' button is pressed regardless of whether or not variables have been initialized.  You will not be prompted to rename or move the current config - it will be overwritten!

## Installation
Unzip the folder to a location of your choosing.  Run the redLeg.ps1 script to launch the GUI.

## Prerequisites
WinRM needs to be enabled on the target hosts for management purposes.  Enabling remote management for target hosts is outside the scope of this document.  Powershell 5.1 or greater is required to properly execute all cmdlets.

## Setting gridCoordinates
Enter the desired values in the corresponding text box fields.  Clicking the "PUSH" button will push the current values onto the stack to be written into the configuration file.  Clicking the "POP" button will pop the last value that was pushed to the stack off the stack before writing it to the configuration file.  Clicking the "CLEAR" button completely clears out any values accumulated on the stak but will not erase values already written to the JSON configuration file.  If these values are no search base changes will be made to the exisiting file.

## Establishing the ammoDump
Clicking the "AMMO" button send the command to download and setup the operations cache.  This only needs to be performed once initally and to establish a fireBase.

## Setting up the fireBase
Clicking the "BASE" button reads the gridCoordinate values and sends advanceParty to prep the gun line.

## Calling fireMission
Clicking the "FIRE MISSION" button sends the command for all guns in the JSON config file to fire for effect.

## Ceasfire
Clicking the "CEASE" button sends the command for all guns in the JSON config file to cease firing.

## Cycle the gun line
When needed, clicking the "CYCLE" button will send the command for all guns in the JSON config file to re-initialize all critical sub-systems and power.

## Move Out
Reads the values in the JSON file and removes all guns established in the fireBase

## Currency list
 
 *    aeon7 (use this for Aeon's new PoW)
 *    bbscoin (automatic switch with block version 3 to cryptonight_v7)
 *    bittube (uses cryptonight_bittube2 algorithm)
 *    freehaven
 *    graft
 *    haven (automatic switch with block version 3 to cryptonight_haven)
 *    intense
 *    masari
 *    monero (use this to support Monero's Oct 2018 fork)
 *    qrl - Quantum Resistant Ledger
 *    ryo
 *    turtlecoin
 *    plenteum
 *    xcash

## License
This project is licensed under the unlicense.
