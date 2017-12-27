cls

# Define Variables
$global:InterfaceIndexNum = 0

<# ************** Functions ************** #>
function GetInterfaceIndex {
    #Get-WmiObject win32_networkadapter -filter 'netconnectionstatus = 2' | select NetConnectionid, Name, Interfaceindex, NetConnectionStatus | Out-Host
    Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object Name, InterfaceDescription,  @{Name="Interfaceindex";Expression={$_."ifIndex"}} , Status | Out-Host

    $global:InterfaceIndexNum = Read-Host "Which Interfaceindex do you want to update?"
}

<# ************** Begin Process ************** #>
# Loops until $WhichAction equals A, R or E
do {
    $WhichAction = Read-Host -Prompt 'Do you want to (A)dd/(R)emove DNS entries or (E)xit?'

    if ($WhichAction -eq 'A') {
        Write-Host 'Starting process to Add DNS Entries...'
        GetInterfaceIndex

        Set-DnsClientServerAddress -Interfaceindex $InterfaceIndexNum -ServerAddresses ('10.200.160.179', '10.200.160.173', '10.200.200.33', '10.200.200.32')

        Write-Host "DNS Entries Added to InterfaceIndex $InterfaceIndexNum"

        Get-NetIPConfiguration -InterfaceIndex $global:InterfaceIndexNum
    }

    elseif ($WhichAction -eq 'R') {
        Write-Host 'Starting process to Remove DNS Entries and restore DHCP...'
        GetInterfaceIndex

        Set-DnsClientServerAddress -Interfaceindex $InterfaceIndexNum -ResetServerAddresses

        Write-Host "DNS Entries Removed from InterfaceIndex $InterfaceIndexNum, DHCP restored"

        ipconfig /all
    }
    elseif ($WhichAction -eq 'E') {
        Write-Host "Exiting without performing any actions..."
        Return
    }    

    else {
        #$End = Read-Host -Prompt 'Invalid entry' + $WhichAction + ', press Enter to close...'
        Write-Warning "Invalid entry ""$WhichAction"", please enter A, R, or E..."
    }
} until ($WhichAction -eq 'A' -or $WhichAction -eq 'R')

Write-Host 'Press Enter to exit...' -ForeGroundColor yellow
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$end = Read-Host