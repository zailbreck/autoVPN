#!/bin/bash

# Localclear Server (CA Server)
lusr=$(eval "whoami")
lpass="ca903"
lhost="server"

# Remote Server (VPN Server)
ruser="vpn"
rpass="vpn903"
rhost=172.100.44.220


echo "[$lusr - Server] Install and Update Package ..."
sshpass -p $lpass sudo apt update -y
sshpass -p $lpass sudo apt install openvpn openssh-server easy-rsa sshpass -y
echo "========================================="

echo "[$lusr - Server] Create Easy-RSA ... "
mkdir ~/autoVPN/easy-rsa
ln -s /usr/share/easy-rsa/* ~/autoVPN/easy-rsa
sshpass -p $lpass sudo chown $lusr ~/autoVPN
chmod 700 ~/autoVPN
echo "========================================="

echo "[$lusr - Server] Create Server Certificates ..."
cd ~/autoVPN/easy-rsa
./easyrsa init-pki
echo "========================================="

# Change This
echo "[$lusr - Server] Create VARS Config (can Modified) ..."
echo 'set_var EASYRSA_REQ_COUNTRY   "ID"
set_var EASYRSA_REQ_PROVINCE        "SUMUT"
set_var EASYRSA_REQ_CITY            "Medan City"
set_var EASYRSA_REQ_ORG             "psi"
set_var EASYRSA_REQ_EMAIL           "psi@mikroskil.ac.id"
set_var EASYRSA_REQ_OU              "Community"
set_var EASYRSA_ALGO                "ec"
set_var EASYRSA_DIGEST              "sha512"' >> vars 
echo "========================================="

echo "[$lusr - Server] BUILD CA ..."
cat << EOF | EASYRSA_REQ_CN=$lhost ./easyrsa --batch build-ca nopass
yes
EOF
echo "========================================="

echo "[$lusr - Server] UPDATE CA ..."
sshpass -p $lpass sudo cp ~/autoVPN/easy-rsa/pki/ca.crt /usr/local/share/ca-certificates/
sshpass -p $lpass sudo update-ca-certificates
echo "========================================="

echo "[$lusr - Server] Import & Sign CA ... "
cd ~/autoVPN/easy-rsa
# import-req <request_file_path> <short_basename>
cat << EOF | ./easyrsa import-req /tmp/${1}.req ${1}
yes
EOF
#   sign-req <type> <filename_base>
cat << EOF | ./easyrsa sign-req server ${1}
yes
EOF
echo "========================================="

echo "[$lusr - Server] Send Back Certificate To VPN Server ... "
sshpass -p $rpass sudo scp ~/autoVPN/easy-rsa/pki/issued/${1}.crt $ruser@$rhost:/tmp
sshpass -p $rpass sudo scp ~/autoVPN/easy-rsa/pki/ca.crt $ruser@$rhost:/tmp
echo "========================================="
sleep 2



