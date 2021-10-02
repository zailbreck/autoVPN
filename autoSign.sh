#!/bin/bash

VPN_USER="vpn"
VPN_PASS="vpn903"
VPN_SERV="192.168.11.183"

cd ~/easy-rsa
cl=${1::-4}
echo "[Remote] Import ..."
# Import Request
cat << EOF | ./easyrsa import-req /tmp/${1} $cl
yes
EOF
echo "========================================="
sleep 1

echo "[Remote] Sign ..."
# Sign Request 
cat << EOF | ./easyrsa sign-req client $cl
yes
EOF
echo "========================================="
sleep 1

# Return Client Signed to Server
echo "[Remote] Send Back ..."
# Send Request CA
sshpass -p $VPN_PASS scp ~/easy-rsa/pki/issued/$cl.crt $VPN_USER@$VPN_SERV:/tmp
sleep 2
echo "Remote Code Success from $cl"
echo "========================================="