# Load the DHCP Server module
     Import-Module DhcpServer

     # Set log file
     $logPath = "C:\Scripts\DHCP_Log.txt"

     # Function to write logs
     function Write-Log {
         param($Message)
         $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
         "$time - $Message" | Out-File -FilePath $logPath -Append
     }

     # Check if DHCP module is available
     if (-not (Get-Module -ListAvailable -Name DhcpServer)) {
         Write-Log "Error: DHCP Server module not found! Ensure DHCP role is installed."
         Write-Host "Error: DHCP Server module not found! Ensure DHCP role is installed."
         exit
     }

     try {
         # Get existing scopes
         $scopes = Get-DhcpServerv4Scope
         Write-Log "Found scopes: $($scopes.Name)"
         Write-Host "Found scopes: $($scopes.Name)"

         # Create a new scope if it doesn't exist
         $scopeName = "SalesNetwork"
         if ($scopes.Name -notcontains $scopeName) {
             Write-Log "Creating new scope: $scopeName..."
             Write-Host "Creating new scope: $scopeName..."
             Add-DhcpServerv4Scope -Name $scopeName -StartRange 192.168.10.100 -EndRange 192.168.10.200 -SubnetMask 255.255.255.0 -State Active -ErrorAction Stop
             Set-DhcpServerv4OptionValue -ScopeId 192.168.10.0 -Router 192.168.10.1 -DnsServer 192.168.10.116 -ErrorAction Stop
             Write-Log "Successfully created and configured scope $scopeName."
             Write-Host "Successfully created and configured scope $scopeName."
         } else {
             Write-Log "Scope $scopeName already exists. Skipping creation."
             Write-Host "Scope $scopeName already exists. Skipping creation."
         }

         # Display current leases
         $leases = Get-DhcpServerv4Lease -ScopeId 192.168.10.0
         Write-Log "Current leases: $($leases.HostName)"
         Write-Host "Current leases: $($leases.HostName)"
     }
     catch {
         Write-Log "Error: $($_.Exception.Message)"
         Write-Host "Error: $($_.Exception.Message)"
     }

     Write-Log "DHCP management completed!"
     Write-Host "DHCP management completed! Check $logPath for details."