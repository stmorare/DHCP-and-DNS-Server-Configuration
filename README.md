# 🌐 DNS and DHCP Configuration Project

## 📋 Overview
This project demonstrates the configuration of **DHCP** and **DNS** services on a Windows Server 2025 domain controller (DC-00) to automate IP address assignment and provide seamless name resolution for the `mydomain.local` domain. The implementation showcases enterprise-level network services integration with Active Directory.

## 🎯 Objectives
- 🔧 Install and configure **DHCP Server** and **DNS Server** roles on DC-00
- 📡 Set up a DHCP scope for automated IP assignment in the `192.168.10.0/24` range
- 🔍 Configure DNS to support Active Directory and resolve `mydomain.local` names
- ✅ Verify IP assignment and name resolution across domain-joined machines
- 📚 Document the complete setup process for portfolio development

## 🛠️ Tools & Technologies Used
| Tool/Technology | Purpose | IP Address |
|---|---|---|
| **Windows Server 2025** | DC-00 - Primary Domain Controller | 192.168.10.116 |
| **Windows Server 2025** | FS-01 - File Server | 192.168.10.117 |
| **Windows 11** | Client Workstation | 192.168.10.118 |
| **Server Manager** | Role installation and management | - |
| **DHCP Console** | DHCP scope configuration | - |
| **DNS Manager** | DNS zone and record management | - |
| **PowerShell/CMD** | Testing and verification | - |
| **Git Bash** | Version control and repository management | - |

## 🚀 Step-by-Step Implementation

### 1️⃣ Environment Preparation
- ✅ Verified domain controller and client connectivity
- 🔐 Ensured all machines are joined to `mydomain.local`
- 💾 Created configuration backup using `netsh dhcp server export`

### 2️⃣ Role Installation
- 📦 Installed **DHCP Server** and **DNS Server** roles via Server Manager
- 🔑 Authorized DHCP server in Active Directory
- 🔄 Configured service startup and dependencies

### 3️⃣ DNS Configuration
- 🌐 Verified Active Directory-integrated DNS zones
- 📝 Created forward lookup zone for `mydomain.local`
- 📍 Added A records for domain resources:
  - `fs-01.mydomain.local` → 192.168.10.117
  - `win11-client.mydomain.local` → 192.168.10.118

### 4️⃣ DHCP Scope Configuration
- 🎯 Created "MainNetwork" scope with IP range: `192.168.10.100-200`
- 🚫 Excluded static IP range: `192.168.10.116-119`
- ⚙️ Configured DHCP options:
  - **Default Gateway**: 192.168.10.1
  - **DNS Server**: 192.168.10.116 (DC-00)
  - **Domain Name**: mydomain.local
  - **Lease Duration**: 8 days

### 5️⃣ Testing & Validation
- 🔄 Performed IP release/renew on client machines
- 🏓 Conducted ping tests for name resolution
- ✅ Verified DHCP lease assignments
- 📊 Confirmed DNS query responses

## 📊 Network Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   DC-00 (PDC)   │    │   FS-01 (FS)    │    │ Windows 11 Client│
│ 192.168.10.116  │    │ 192.168.10.117  │    │ 192.168.10.118  │
│   DHCP + DNS    │    │   File Server   │    │   Workstation   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
                    ┌─────────────────┐
                    │   Router/GW     │
                    │  192.168.10.1   │
                    └─────────────────┘
```

## 🔧 Configuration Details

### DHCP Scope Settings
- **Scope Name**: MainNetwork
- **IP Range**: 192.168.10.100 - 192.168.10.200
- **Subnet Mask**: 255.255.255.0 (/24)
- **Lease Duration**: 8 days
- **Exclusions**: 192.168.10.116-119 (Static IPs)

### DNS Zone Configuration
- **Zone Type**: Active Directory Integrated
- **Zone Name**: mydomain.local
- **Dynamic Updates**: Secure only
- **Replication**: All DNS servers in the domain

## 📈 Results & Verification

### ✅ Successful Outcomes
- 🎯 DHCP scope active with 101 available addresses
- 🔍 DNS resolution working for all domain resources
- 🔄 Automatic IP assignment functioning correctly
- 📱 Client machines successfully joined and communicating

### 🧪 Test Results
```bash
# DNS Resolution Tests
ping fs-01.mydomain.local        # ✅ Success: 192.168.10.117
ping win11-client.mydomain.local # ✅ Success: 192.168.10.118
nslookup mydomain.local          # ✅ Success: Zone found
```

## 🤝 Acknowledgements
- 🤖 Collaborated with **Grok 3**, built by xAI, for expert guidance and assistance
- 🎯 Collaborated with **Claude Sonnet 4**, built by Anthropic, for expert guidance and assistance
