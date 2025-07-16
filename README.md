# DNS and DHCP Configuration Project

## Overview
This project configures DHCP and DNS services on DC-00 to automate IP address assignment and provide name resolution for the `mydomain.local` domain. 
The setup includes installing the necessary roles, configuring a DHCP scope for the 192.168.10.0/24 network, integrating DNS with Active Directory, and verifying 
functionality on the Windows 11 client and FS-01. The process is documented and uploaded to GitHub for your portfolio.

## Objectives
- Install and configure the DHCP Server and DNS Server roles on DC-00.
- Set up a DHCP scope to assign IP addresses in the 192.168.10.0/24 range.
- Configure DNS to support Active Directory and resolve `mydomain.local` names.
- Verify IP assignment and name resolution on the Windows 11 client and FS-01.
- Document the setup and results for a portfolio on GitHub.

## Tools Used
- **Windows Server 2025**: DC-00 (192.168.10.116) as DHCP and DNS server, FS-01 (192.168.10.117), Windows 11 client (192.168.10.118).
- **Server Manager**: For role installation.
- **DHCP Console**: For scope configuration.
- **DNS Manager**: For DNS settings.
- **Command Prompt/PowerShell**: For verification.
- **Git Bash**: For uploading to GitHub.

## Step-by-Step Procedure

### Step 1: Prepare the Environment
1. **Verify Current Setup**:
   - Ensure DC-00, FS-01, and the Windows 11 client are running and joined to `mydomain.local`.
   - Confirm static IP assignments: DC-00 (192.168.10.116), FS-01 (192.168.10.117), client (192.168.10.118).
   - Note the current DNS server (likely DC-00 or DC-01 at 192.168.10.119).
2. **Backup Current Configuration**:
   - On DC-00, open **Command Prompt** and run:
     ```cmd
     netsh dhcp server export C:\DHCP-Backup.txt all
     ```
   - Ensure `C:\` has space for the backup file.

### Step 2: Install DHCP and DNS Roles on DC-00
1. **Install Roles**:
   - Open **Server Manager** > **Manage** > **Add Roles and Features**.
   - **Role-based or feature-based installation** > **Next**.
   - Select DC-00 > Expand **Roles** > Check **DHCP Server** and **DNS Server** > **Next** > **Install**.
   - Confirm completion and restart if prompted.
2. **Authorize DHCP Server**:
   - Open **DHCP** console (**Server Manager** > **Tools** > **DHCP**).
   - Right-click the server name (DC-00) > **Authorize**.

### Step 3: Configure DNS Server
1. **Open DNS Manager**:
   - **Server Manager** > **Tools** > **DNS**.
2. **Verify Active Directory Integration**:
   - Expand DC-00 > **Forward Lookup Zones** > Confirm `mydomain.local` exists with AD-integrated records.
   - If missing, right-click **Forward Lookup Zones** > **New Zone** > **Next** > **Primary Zone** > **To all DNS servers in this domain** > **Next** > Zone name: `mydomain.local` > **Next** > **Allow only secure dynamic updates** > **Next** > **Finish**.
3. **Add A Records**:
   - Right-click `mydomain.local` > **New Host (A or AAAA)**.
   - Name: `fs-01`, IP address: 192.168.10.117 > **Add Host** > **OK**.
   - Repeat for client: Name: `win11-client`, IP: 192.168.10.118 > **OK**.

### Step 4: Configure DHCP Scope
1. **Open DHCP Console**:
   - **Server Manager** > **Tools** > **DHCP**.
2. **Create New Scope**:
   - Right-click the server name > **New Scope**.
   - **Scope Name**: `MainNetwork` > **Next**.
   - **IP Range**: Start IP: 192.168.10.100, End IP: 192.168.10.200 > **Next**.
   - **Subnet Mask**: 255.255.255.0 > **Next**.
   - **Exclusions**: Exclude 192.168.10.116-119 (for static IPs) > **Add** > **Next**.
   - **Lease Duration**: 8 days > **Next**.
   - **Configure DHCP Options**: **Yes** > **Next**.
   - **Router (Default Gateway)**: 192.168.10.1 > **Next**.
   - **Parent Domain**: `mydomain.local` > **Next**.
   - **DNS Servers**: 192.168.10.116 (DC-00) > **Next**.
   - **WINS Servers**: **No** > **Next**.
   - **Activate Scope**: **Yes** > **Next** > **Finish**.

### Step 5: Apply and Test Configuration
1. **Release and Renew IP on Client**:
   - On the Windows 11 client, open **Command Prompt** and run:
     ```cmd
     ipconfig /release
     ipconfig /renew
     ```
   - Verify new IP (e.g., 192.168.10.100-200) with `ipconfig /all`.
2. **Test DNS Resolution**:
   - On the client, run:
     ```cmd
     ping fs-01.mydomain.local
     ping win11-client.mydomain.local
     ```
   - Confirm responses match 192.168.10.117 and 192.168.10.118.
3. **Verify FS-01**:
   - On FS-01, release and renew IP (`ipconfig /release` and `ipconfig /renew`).
   - Check `ipconfig /all` for a DHCP-assigned IP and DNS server as 192.168.10.116.

### Step 6: Document and Upload
1. **Screenshots**:
   - DHCP scope configuration in DHCP console.
   - DNS records in DNS Manager.
   - `ipconfig /all` output on client and FS-01.
   - Ping results from client.
2. **GitHub Upload**:
   - Create repository `DNS-and-DHCP-Configuration-Project`.
   - **Git Bash**:
     ```bash
     cd /c/SystemAdminProjects/DNS-and-DHCP-Configuration-Project
     git init
     git add .
     git commit -m "Completed DNS and DHCP Configuration Project"
     git remote add origin https://github.com/your-username/DNS-and-DHCP-Configuration-Project.git
     git push -u origin main
3. **Acknowledgements**:
   - Collaborated with Grok 3, built by xAI, for expert guidance and assistance in completing this project.
   - Collaborated with Claude Sonnet 4, built by Anthropic, for expert guidance and assistance in completing this project.

  
