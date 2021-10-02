#!/bin/bash

CA_USER="ca"
CA_PASS="ca903"
CA_SERV="192.168.11.177"

echo "[Local] Make Request ..."
cd ~/easy-rsa
cat << EOF | ./easyrsa gen-req ${1} nopass
yes
EOF
echo "========================================="
echo "[Local] Backup Key ..."
cp ~/easy-rsa/pki/private/${1}.key ~/client-configs/keys/
echo "========================================="

# Send Request CA
echo "[Local] Send Request to CA ..."
sshpass -p $CA_PASS scp ~/easy-rsa/pki/reqs/${1}.req $CA_USER@$CA_SERV:/tmp
echo "========================================="

# Remote Script Execute
echo "[Local] Run Remote Execute ..."
sshpass -p $CA_PASS ssh $CA_USER@$CA_SERV "cd ~/autoVPN/ ; ./autoSign.sh ${1}.req"
echo "========================================="

# After Client at Sign 
echo "[Local] Backup Certificate ..."
cp /tmp/${1}.crt ~/client-configs/keys/
echo "========================================="

# Generate OVPN File
cd ~/client-configs
echo "[Local] Generate OVPN Files ..."
./make_config.sh ${1}
echo "========================================="
echo "Your File in /home/vpn/client-configs/files/${1}.ovpn"