# Step-by-Step Guide: DNS and DHCP Configuration Project (Windows Server 2025)

## 1. Environment Preparation

### 1.1. Verify Connectivity
- Ensure all VMs (domain controller, file server, Windows 11 client) are powered on and connected to the same internal/bridged network in VMware.
- Test network connectivity (e.g., from DC-00, `ping fs-01`, `ping win11-client`).

### 1.2. Check Domain Membership
- Log in to each server/client and verify they are joined to `mydomain.local`.
  - Open **System Properties** (`sysdm.cpl`), confirm Domain: `mydomain.local`.

### 1.3. Backup Existing DHCP Config (if upgrading)
- On DC-00 (if an existing DHCP server), open **Command Prompt** (as Admin):
  ```
  netsh dhcp server export C:\backup\dhcpdb.dat all
  ```

## 2. Role Installation

### 2.1. Add DHCP & DNS Server Roles
- Open **Server Manager** on DC-00.
- Go to **Manage > Add Roles and Features**.
- Choose **Role-based or feature-based installation**.
- Select the **DC-00** server.
- Under **Server Roles**:
  - Check **DHCP Server**. Click **Add Features** when prompted.
  - Check **DNS Server** (if not already installed).
- Click **Next** until the **Install** button appears, then **Install**.
- Wait for the installation to complete.

### 2.2. Post-Install Configuration
- In **Server Manager**, click the notifications (!) flag and **Complete DHCP configuration**.
- **Authorize DHCP** in Active Directory (if prompted; use your domain administrator account).
- Ensure both **DHCP Server** and **DNS Server** services are running:
  - Open **Services.msc**
  - Check status of `DHCP Server` and `DNS Server`

## 3. DNS Configuration

### 3.1. Open DNS Manager
- From **Server Manager > Tools > DNS**.

### 3.2. Confirm or Create Forward Lookup Zone
- In **DNS Manager**, expand your DC-00 > **Forward Lookup Zones**.
- Confirm `mydomain.local` exists as a zone type **Active Directory-Integrated**.
  - If missing: Right-click **Forward Lookup Zones** > **New Zone...**
    - **Primary zone**
    - **Store in Active Directory** (integrated)
    - **Zone name:** `mydomain.local`
    - **Allow only secure dynamic updates**

### 3.3. Add Host (A) Records
- Right-click on zone `mydomain.local` > **New Host (A or AAAA)...**
  - **Name:** fs-01  **IP address:** 192.168.10.117
  - **Name:** win11-client  **IP address:** 192.168.10.118
  - Optionally, tick **Create associated PTR record**.

## 4. DHCP Scope Configuration

### 4.1. Open DHCP Console
- **Server Manager > Tools > DHCP**

### 4.2. Create DHCP Scope
- Expand DC-00 > right-click **IPv4 > New Scope...**
  - **Scope Name:** MainNetwork
  - **Starting IP address:** 192.168.10.100
  - **Ending IP address:** 192.168.10.200
  - **Subnet Mask:** 255.255.255.0 (/24)
  - **Add Exclusions:** 192.168.10.116-192.168.10.119 (static IPs for servers/critical devices)
  - **Lease Duration:** 8 Days

### 4.3. Set DHCP Options (for scope)
- When prompted (or right-click Scope > **Properties > Scope Options**):
  - **003 Router:** 192.168.10.1 *(your default gateway/router)*
  - **006 DNS Servers:** 192.168.10.116 *(the DC/DNS server)*
  - **015 DNS Domain Name:** mydomain.local

- Activate the scope if not auto-activated.

## 5. Testing and Validation

### 5.1. Force IP Lease on Clients
- On Windows 11 client:
  ```
  ipconfig /release
  ipconfig /renew
  ```
- Verify assigned IP is from the DHCP range (192.168.10.100–200), not from static/excluded.

### 5.2. Name Resolution Tests
- From the client:
  ```
  ping fs-01.mydomain.local
  ping win11-client.mydomain.local
  nslookup mydomain.local
  ```
- All should resolve to correct IP addresses.
- If not, check firewall settings and network adapter configuration.

### 5.3. View DHCP Leases
- In **DHCP Console** > Scope > **Address Leases**: See the client listed with correct IP and computer name.

### 5.4. Verify DNS Zone Records
- In **DNS Manager**, check that A records exist for all machines, and that dynamic updating works.

## 6. Documentation and Screenshots

- Take screenshots of:
  - **DHCP scope** and **active leases**
  - **DNS zone** with A records
  - **ipconfig /all** on the client (shows DHCP lease, DNS config)
  - **cmd** output for ping/nslookup confirming name resolution

## 7. Troubleshooting

- **Clients not getting IP:** Check if DHCP Scope is active, exclusions aren’t covering entire range, and the client is set to obtain IP automatically.
- **DNS not resolving:** Confirm DNS server IP on client, ensure A records exist, try `ipconfig /flushdns` on the client.
- **DHCP server not authorized:** In DHCP Console, right-click server > **Authorize**.
- **Network issues:** Disable Windows Firewall temporarily to rule out blocks.

## 8. Next Steps & Best Practices

- Consider **DHCP failover** (split-scope or hot standby) for redundancy.
- For advanced security, configure **DNSSEC** in DNS Manager.
- Monitor service health (Event Viewer, Server Manager dashboard).

## 9. Result Summary

- DHCP dynamically assigns IP addresses from `192.168.10.100-200` to clients.
- DNS resolves names for `mydomain.local` and all machines.
- All domain-joined clients communicate seamlessly by name/IP.

By following this guide, you'll successfully deploy enterprise-grade automatic IP addressing and name resolution, fully integrated with Active Directory on Windows Server 2025.
