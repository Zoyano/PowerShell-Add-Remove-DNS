# PowerShell-Add-Remove-DNS
      ___         ___         ___         ___                   ___         ___     
     /\  \       /\  \       /\  \       /\  \                 /\__\       /\  \    
    /::\  \     /::\  \     /::\  \     /::\  \               /::|  |     /::\  \   
   /:/\:\  \   /:/\:\  \   /:/\:\  \   /:/\:\  \             /:|:|  |    /:/\:\  \  
  /::\~\:\  \ /::\~\:\  \ /::\~\:\  \ /:/  \:\__\           /:/|:|__|__ /::\~\:\  \ 
 /:/\:\ \:\__/:/\:\ \:\__/:/\:\ \:\__/:/__/ \:|__|         /:/ |::::\__/:/\:\ \:\__\
 \/_|::\/:/  \:\~\:\ \/__\/__\:\/:/  \:\  \ /:/  /         \/__/~~/:/  \:\~\:\ \/__/
    |:|::/  / \:\ \:\__\      \::/  / \:\  /:/  /                /:/  / \:\ \:\__\  
    |:|\/__/   \:\ \/__/      /:/  /   \:\/:/  /                /:/  /   \:\ \/__/  
    |:|  |      \:\__\       /:/  /     \::/__/                /:/  /     \:\__\    
     \|__|       \/__/       \/__/       ~~                    \/__/       \/__/    

PowerShell script to:
1. Add specified DNS server entries to the chosen adapter, or
2. Remove manual DNS server entries and reset back to DHCP

If adding DNS entries, must modify the variable at the top named '$Global:DNSEntries'
with a comma delimited list of IP's to add as DNS servers.  Follow example format of 'IP1', 'IP2'.