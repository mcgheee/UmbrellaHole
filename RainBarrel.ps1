Param (
    [switch]$Clean
)

$hostsfile = 'C:\Windows\System32\drivers\etc\hosts' #location of hosts File
$lmhostsfile = 'C:\Windows\System32\drivers\etc\lmhosts.sam' #Location of lmhosts file
$DNSServer = "dns.your.domain" #Your DNS Server
$ZoneName = "your.domain" #Target Zone to cache

#Set a place to put a backup of your original host files. This will only be written to
# if the $clean switch is on, or the $ManagedLine is missing from the files. 
$Hostsbackupfile = 'C:\hosts.bak'
$lmhostsbackupfile = 'C:\lmhosts.bak'

#Line to Denote where management starts.
#Entries above this line will be preserved.
#Entries below will be changed by this script.
$ManagedLine = '# ---ENTRIES BELOW THIS LINE ARE MANAGED---'

if ($Clean){
    # Get & Preserve Unmanaged content of hosts File
    $hostcontent = Get-Content $hostsfile
    $NewHostContent = @()
    $startline = ($hostcontent.IndexOf($ManagedLine))
    if ($startline -eq -1) {
        Copy-Item -Path $hostsfile -Destination $hostsbackupfile
        $NewHostContent = $hostcontent
    }
    else {for ($i=0;$i -lt ($startline);$i++){$NewHostContent += $hostcontent[$i]}}
    
    # Get & Preserve Unmanaged content of lmhosts File
    $lmhostcontent = Get-Content $lmhostsfile
    $NewlmHostContent = @()
    $startline = ($lmhostcontent.IndexOf($ManagedLine))
    if ($startline -eq -1) {
        Copy-Item -Path $lmhostsfile -Destination $lmhostsbackupfile
        $NewlmHostContent = $lmhostcontent
    }
    else {for ($i=0;$i -lt ($startline);$i++){$NewLMHostContent += $hostcontent[$i]}}
}
else {
    # Get & Preserve Unmanaged content of hosts File
    $hostcontent = Get-Content $hostsfile
    $NewHostContent = @()
    $startline = ($hostcontent.IndexOf($ManagedLine))
    if ($startline -eq -1) {
        Copy-Item -Path $hostsfile -Destination $hostsbackupfile
        $hostcontent += $ManagedLine
        $NewHostContent = $hostcontent
    }
    else {
        for ($i=0;$i -lt ($startline+1);$i++){$NewHostContent += $hostcontent[$i]}
    }

    # Get & Preserve Unmanaged content of lmhosts File
    $lmhostcontent = Get-Content $lmhostsfile
    $NewlmHostContent = @()
    $startline = ($lmhostcontent.IndexOf($ManagedLine))
    if ($startline -eq -1) {
        Copy-Item -Path $lmhostsfile -Destination $lmhostsbackupfile
        $lmhostcontent += $ManagedLine
        $NewlmHostContent = $lmhostcontent
    }
    else {
        for ($i=0;$i -lt ($startline+1);$i++){$NewLMHostContent += $hostcontent[$i]}
    }

    #Get A records from the target zone.
    $entries = $null
    $entries = @()
    $Zone = (Get-DnsServerZone -ComputerName $DNSServer | Where-Object {$_.ZoneName -like $ZoneName})
    $records = ($Zone | Get-DnsServerResourceRecord -ComputerName $DNSServer -RRType "A")
    foreach ($record in $records){
        if (($record.HostName -notcontains '.') -and ($record.HostName -notcontains '@') -and ($record.RecordData.IPv4Address -match '^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$')){

            $entries += @($record.RecordData.IPv4Address.ToString(), $record.HostName.ToString())
        }
    }

    <# NOT YET WORKING
    #Get CNAMES from target zone, Compare target hostname to A Records, if match is found, add entry with CNAME alias pointing to A Record's IP
    $records = ($Zone | Get-DnsServerResourceRecord -ComputerName $DNSServer -RRType "CNAME")
    foreach ($record in $records){
        $searchstring = ($record.RecordData.HostNameAlias.ToString()).TrimEnd("$($ZoneName).")
        foreach ($entry in $entries){
            if ($entry -match $searchstring){
                $entries += @($entries[$entries.IndexOf($entry) - 1], $record.HostName)
            }
        }
    }
    #>

    #Add records to Host Content
    for ($i=0;$i -lt $entries.Count; $i+=2){
        $entry = "$($entries[$i])`t`t$($entries[$i+1]).$($zonename)"
        $NewHostContent += $entry
    }

    #Add records to LMHOST Content
    for ($i=0;$i -lt $entries.Count; $i+=2){
        $entry = "$($entries[$i])`t`t$($entries[$i+1]).$($zonename)`t`t#PRE"
        $NewLMHostContent += $entry
    }
}

#Write new content to Host Files
$NewHostContent | Out-File $hostsfile
$NewlmHostContent | Out-File $lmhostsfile