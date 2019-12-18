# UmbrellaHole
De-filter DNS on your Windows Host.
Allows for caching local DNS entries to retain access to LAN hosts while switching DNS to a public provider.

**REQUIRES WINDOWS RSAT!**

Get it here: https://www.microsoft.com/en-us/download/details.aspx?id=45520

### Contents
- `GetWet.ps1` - Script to switch between public DNS servers on a Windows client; including CloudFlare, OpenDNS, & Google.
- `RainBarrel.ps1` - Script to cache Local DNS A Records in host file.

## Use Instructions
1. Install Windows RSAT
2. Download Scripts
3. Edit variables in RainBarrel.ps1 to suit your environment. Take note of the backup file locations!
4. Click Start, navigate to PowerShell, right-click on the shortcut & select RunAs Administrator
5. In the PowerShell window, run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force`
6. Navigate to where you saved the files. Ex: `cd C:\Users\Username\Desktop\`
7. Run command : `.\RainBarrel.ps1` - N
8. Run command : `.\GetWet.ps1`
8. Listen to https://www.youtube.com/watch?v=VT6LFOIofRE

## Optional Parameters
Optional Paramters can be discovered by typing the command to run the script (ex: `.\GetWet.ps1`), and the pressing `TAB`.
These Parameters are not necessary for use, but may be used as a shortcut to obtain information or to avoid interaction.

### GetWet.ps1
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

### RainBarrel.ps1
- **-Clean** - Removes all managed entries from the hosts file.
