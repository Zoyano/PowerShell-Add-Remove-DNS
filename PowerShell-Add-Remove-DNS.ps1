Clear-Host

<#************** Enter List of DNS IP's here for Adding **************#>
$Global:DNSEntries = '10.200.160.179', '10.200.160.173', '10.200.200.33', '10.200.200.32'
#$Global:DNSEntries = '10.80.72.4', '10.11.0.23' #Backup for VPN Connection

<#************** Functions **************#>
function AddRemove-DNSEntries ($x) {
    #Define Variables
    $InterfaceIndexNum = 0
    $DefaultIndexNum = Get-DnsClientServerAddress -InterfaceAlias Ethernet -AddressFamily IPv4

    #Get-WmiObject win32_networkadapter -filter 'netconnectionstatus = 2' | select NetConnectionid, Name, Interfaceindex, NetConnectionStatus | Out-Host
    
    #Display list of connected Network Adapters for user to find InterfaceIndexnum
    Get-NetAdapter | Where-Object Status -eq 'Up' |
        Select-Object Name, InterfaceDescription, @{Name = "Interfaceindex"; Expression = {$_."ifIndex"}} , Status | Out-Host

    $InterfaceIndexNum = Read-Host "Which Interfaceindex do you want to $x DNS entries for (E to default to Ethernet)?"
    Write-Host ""

    #Use InterfaceIndex of Ethernet adapter if user entered E
    if ($InterfaceIndexNum -eq 'E') {
        $InterfaceIndexNum = $DefaultIndexNum.InterfaceIndex
    }

    #if Add was passed to function, run add DNS entries process
    if ($x -eq 'Add') {
        Set-DnsClientServerAddress -Interfaceindex $InterfaceIndexNum -ServerAddresses ($Global:DNSEntries) -ErrorAction Stop
        #Set-DnsClientServerAddress -Interfaceindex $InterfaceIndexNum -ServerAddresses ($Global:DNSEntries) -WhatIf
        Write-Host "DNS Entries Added to InterfaceIndex $InterfaceIndexNum" -ForegroundColor green
    }

    #if Remove was passed to function, run remove DNS entries process
    elseif ($x -eq 'Remove') {
        Set-DnsClientServerAddress -Interfaceindex $InterfaceIndexNum -ResetServerAddresses -ErrorAction Stop
        #Set-DnsClientServerAddress -Interfaceindex $InterfaceIndexNum -ResetServerAddresses -WhatIf
        Write-Host "DNS Entries Removed from InterfaceIndex $InterfaceIndexNum, DHCP restored" -ForegroundColor Green
    }

    Get-NetIPConfiguration -InterfaceIndex $InterfaceIndexNum
}

<#************** Begin Process **************#>
# Loops until $WhichAction equals A, R or E
do {
    $WhichAction = Read-Host -Prompt 'Do you want to (A)dd/(R)emove DNS entries or (E)xit?'

    #(A)dd DNS Entries
    if ($WhichAction -eq 'A') {
        Write-Host 'Starting process to Add DNS Entries...' -ForegroundColor Green
        AddRemove-DNSEntries('Add')
    }

    #(R)emove DNS Entries
    elseif ($WhichAction -eq 'R') {
        Write-Host 'Starting process to Remove DNS Entries and restore DHCP...' -ForegroundColor Green
        AddRemove-DNSEntries('Remove')
    }

    #(E)xit the program
    elseif ($WhichAction -eq 'E') {
        Write-Host "Exiting without performing any actions..." -ForegroundColor Red
        Return
    }    

    #Error catching
    else {
        Write-Warning "Invalid entry ""$WhichAction"", please enter A, R, or E..."
    }
} until ($WhichAction -eq 'A' -or $WhichAction -eq 'R')

Write-Host 'Press Enter to exit...' -ForeGroundColor yellow
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$end = Read-Host