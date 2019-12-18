# UmbrellaHole
Script to switch between public DNS servers on a Windows client; including CloudFlare, OpenDNS, & Google.

## Use Instructions
1. Download Script
2. Click Start, navigate to PowerShell, right-click on the shortcut & select RunAs Administrator
3. In the PowerShell window, run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force`
4. Navigate to where you saved the file. Ex: `cd C:\Users\Username\Desktop\`
5. Run command : `.\GetWet.ps1`
6. Listen to https://www.youtube.com/watch?v=VT6LFOIofRE

## Optional Parameters
Optional Paramters can be found by typing `.\GetWet.ps1` , and the pressing `TAB`.

These Parameters are not necessary for use, but may be used as a shortcut to obtain information or to avoid interaction.
- **-SetProvider** : Accepts a DNS Provider by name.
  - ex: `.\GetWet.ps1 -SetProvider Google` 
- **-SetInterfaceIndex** - Accepts an InterfaceIndex number.
  - ex: `.\GetWet.ps1 -SetInterfaceIndex 5`
- **-ListProviders** - Returns a list of availalbe providers.
  - ex: `.\GetWet.ps1 -ListProviders`
- **-ListInterfaces** - Returns a list of availalbe Network Interfaces.
  - ex: `.\GetWet.ps1 -ListInterfaces`
- **-Reset** - Resets an interface to obtain it's DNS server from DHCP
 - ex: `.\GetWet.ps1 -SetInterfaceIndex 5 -Reset'
