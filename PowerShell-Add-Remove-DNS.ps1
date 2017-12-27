cls

# Define Variables
$global:InterfaceIndexNum = 0
<#************** Enter List of DNS IP's here for Adding **************#>
#$global:DNSEntries = ('10.200.160.179', '10.200.160.173', '10.200.200.33', '10.200.200.32')

<#************** Functions **************#>
function AddRemove-DNSEntries ($x) {
    #Get-WmiObject win32_networkadapter -filter 'netconnectionstatus = 2' | select NetConnectionid, Name, Interfaceindex, NetConnectionStatus | Out-Host
    Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object Name, InterfaceDescription, @{Name = "Interfaceindex"; Expression = {$_."ifIndex"}} , Status | Out-Host

    if ($x -eq 'Add') {
        $global:InterfaceIndexNum = Read-Host "Which Interfaceindex do you want to Add DNS entries to?"
        Set-DnsClientServerAddress -Interfaceindex $global:InterfaceIndexNum -ServerAddresses ('10.200.160.179', '10.200.160.173', '10.200.200.33', '10.200.200.32')
        Write-Host "DNS Entries Added to InterfaceIndex $global:InterfaceIndexNum"
        Get-NetIPConfiguration -InterfaceIndex $global:InterfaceIndexNum
    }
    
    elseif ($x -eq 'Remove') {
        $global:InterfaceIndexNum = Read-Host "Which Interfaceindex do you want to Remove DNS entries from?"
        Set-DnsClientServerAddress -Interfaceindex $global:InterfaceIndexNum -ResetServerAddresses
        Write-Host "DNS Entries Removed from InterfaceIndex $global:InterfaceIndexNum, DHCP restored"
        Get-NetIPConfiguration -InterfaceIndex $global:InterfaceIndexNum
    }
}

<#************** Begin Process **************#>
# Loops until $WhichAction equals A, R or E
do {
    $WhichAction = Read-Host -Prompt 'Do you want to (A)dd/(R)emove DNS entries or (E)xit?'

    #(A)dd DNS Entries
    if ($WhichAction -eq 'A') {
        Write-Host 'Starting process to Add DNS Entries...'
        AddRemove-DNSEntries('Add')
    }

    #(R)emove DNS Entries
    elseif ($WhichAction -eq 'R') {
        Write-Host 'Starting process to Remove DNS Entries and restore DHCP...'
        AddRemove-DNSEntries('Remove')
    }

    #(E)xit the program
    elseif ($WhichAction -eq 'E') {
        Write-Host "Exiting without performing any actions..."
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