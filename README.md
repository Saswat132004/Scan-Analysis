# Comprehensive Network Security Lab Report
**Infrastructure Environment:** Isolated VirtualBox Host-Only Network  
**Target Node IP:** `192.168.56.102`  
**Attacker Node Platform:** Kali Linux VM (`192.168.56.100`)

---

## 🔍 Phase 1: Network Discovery & Reconnaissance
To establish line-of-sight tracking within our private laboratory segment, a Layer-2 Address Resolution Protocol (ARP) broad-scope evaluation was executed via the `netdiscover` utility.

### Network Target Topology Map
| Discovered IP | Physical MAC Address | Packet Count | Vendor Identity / Role |
| :--- | :--- | :--- | :--- |
| **192.168.56.1** | `0a:00:27:00:00:15` | 1 | VirtualBox Network Gateway Interface |
| **192.168.56.100** | `08:00:27:0f:4b:0a` | 1 | Local Kali Linux Attacker Node |
| **192.168.56.102** | `08:00:27:86:fa:1d` | 1 | **Target: Metasploitable2 Instance** |

---

## 🛠️ Phase 2: Attack Surface Scanning & Version Auditing
An active Transmission Control Protocol (TCP) stealth SYN sweep, operating system identification, and aggressive service version check sequence were deployed against the target node.

### Exposed Services Directory
* **Port 21/TCP:** FTP (vsftpd 2.3.4)
* **Port 22/TCP:** SSH (OpenSSH 4.7p1)
* **Port 23/TCP:** Telnet (Linux telnetd)
* **Port 25/TCP:** SMTP (Postfix smtpd)
* **Port 53/TCP:** DNS (ISC BIND 9.4.2)
* **Port 80/TCP:** HTTP (Apache httpd 2.2.8 hosting DVWA/Mutillidae)
* **Port 1099/TCP:** Java RMI (GNU Classpath grmiregistry)
* **Port 5432/TCP:** PostgreSQL DB (8.3.0 - 8.3.7)
* **Port 8180/TCP:** HTTP (Apache Tomcat/Coyote JSP engine 1.1)

---

## 🚨 Phase 3: Deep-Dive Vulnerability Analysis Matrix
Using the Nmap Scripting Engine (NSE) vulnerability scanning modules (`--script=vuln`), service layers were evaluated against public CVE indexes to highlight operational security risks.

| Vulnerability Vector | CVE Index | Severity Rank | Technical Exploit Mechanism |
| :--- | :--- | :--- | :--- |
| **vsFTPd Backdoor** | CVE-2011-2523 | **Critical (10.0)** | Contains an application-layer trigger. Submitting a specific character sequence (like `:)`) to the username field opens a hidden, unauthenticated root shell listener bound to Port 6200. |
| **SSL POODLE Attack** | CVE-2014-3566 | **High (7.7)** | Postfix and PostgreSQL daemons support outdated SSLv3.0. A man-in-the-middle attacker can exploit padding oracles to decrypt private connection blocks. |
| **Java RMI Code Execution** | N/A | **High (9.0)** | The default configuration of the RMI registry allows loading application classes from remote URLs, enabling remote attackers to achieve arbitrary code execution. |
| **Slowloris Web DoS** | CVE-2007-6750 | **Medium (5.0)** | The Apache server fails to time-out lingering, partial HTTP header packets. An attacker can consume the server pool connections, knocking the applications offline. |

---

## 📦 Phase 4: Packet Analysis & Credential Interception
To evaluate data privacy exposures, live packet frames were sniffed on the interface via **Wireshark** during an authentication attempt to the target's unencrypted FTP server.

### Packet Capture Workflow Details
1. **Network Tap:** Wireshark initiated live capture parsing across interface `eth0`.
2. **Traffic Generation:** A terminal session simulated a live interaction by calling `ftp 192.168.56.102`. User submitted username `saswat` and password `Password123!`.
3. **Stream Reconstruction:** The filter expression `ftp` was applied to isolate the transaction. Recompiling the sequence via **Follow -> TCP Stream** rendered the complete cleartext interaction:

```text
220 (vsFTPd 2.3.4)
USER saswat
331 Please specify the password.
PASS Password123!
530 Login incorrect.
