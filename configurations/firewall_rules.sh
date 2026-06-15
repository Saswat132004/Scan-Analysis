#!/bin/bash
# Root permission verification
if [ "$EUID" -ne 0 ]; then
  echo "[-] Access Denied: Execute as root/sudo"
  exit 1
fi

echo "[+] Hardening Netfilter packet processing rules..."

# 1. Port Hardening: Drop unauthorized connections targeting HTTP Port 80
iptables -A INPUT -p tcp --dport 80 -j DROP

# 2. Host Blacklisting: Block access from an aggressive network node
iptables -A INPUT -s 192.168.56.1 -j DROP

# Verification Command
echo "[+] Active Core Netfilter Rules Injected:"
iptables -L INPUT -v -n
