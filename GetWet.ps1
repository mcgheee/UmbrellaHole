Param (
    [Parameter(ValueFromPipeline=$true,Position=1)][string]$SetProvider,
    [Parameter(ValueFromPipeline=$true,Position=2)][int]$SetInterfaceIndex,
    [alias("providers")][switch]$ListProviders,
    [alias("ints")][switch]$ListInterfaces,
    [switch]$Reset
)

$Providers = $null
$Providers = @{}
$Providers.Add("default",   (@{weight = 1; primary = "DHCP";            secondary = "DHCP"}))
$Providers.Add("OpenDNS",   (@{weight = 2; primary = "208.l67.222.222"; secondary = "208.67.220.220"}))
$Providers.Add("CloudFlare",(@{weight = 3; primary = "1.1.1.1";         secondary = "1.0.0.1"}))
$Providers.Add("APNIC",     (@{weight = 4; primary = "1.1.1.1";         secondary = "1.1.2.2"}))
$Providers.Add("Google",    (@{weight = 5; primary = "8.8.8.8";         secondary = "8.8.4.4"}))

function List-Providers{
    $lines = @()
    foreach ($key in $Providers.Keys) {
        $lines += "$($Providers[$key].weight). $($key) -  $($Providers[$key].primary), $($Providers[$key].secondary)"
    }
    Write-Host "Possible Providers:"
    $lines | sort
}

function List-Interfaces{
    Get-NetIPAddress | select -Property IPAddress,InterfaceAlias, InterfaceIndex | sort -Property InterfaceIndex | Format-Table
    Write-Host "You probably want InterfaceIndex $(Get-NetIPAddress | Where-Object {$_.InterfaceAlias -like "ethernet"} | select -ExpandProperty InterfaceIndex) ..."
}

if ($ListProviders) {List-Providers; exit}

if ($ListInterfaces) {List-Interfaces; exit}

if ((!$SetProvider -and !$Reset) -or (($SetProvider -notin $Providers.Keys) -and !$Reset)){
    List-Providers
    do{
        $choice = $null
        $choice = Read-Host "`r`nPlease enter a # for a provider from the list above"
        foreach ($key in $Providers.Keys) {if ($choice -eq $Providers[$key].weight) {$SetProvider = $key}}
    } until ($SetProvider -in $Providers.Keys)
}

if ((!$SetInterfaceIndex) -or ( $SetInterfaceIndex -notin (Get-NetIPInterface | Select -ExpandProperty ifIndex) )){
    List-Interfaces
    do{
        $choice = $null
        $choice = Read-Host "Please enter a # for an InterfaceIndex from the list above"
        if ($choice -in (Get-NetIPInterface | Select -ExpandProperty ifIndex)) {$SetInterfaceIndex = $choice} else {$SetInterfaceIndex = $null}
    } until($SetInterfaceIndex)
}

if ($Reset -or ($SetProvider -like "default")) {Set-DnsClientServerAddress -InterfaceIndex $SetInterfaceIndex -ResetServerAddresses}
else {Set-DnsClientServerAddress -ServerAddresses ($Providers[$SetProvider].primary,$Providers[$SetProvider].secondary) -InterfaceIndex $SetInterfaceIndex}