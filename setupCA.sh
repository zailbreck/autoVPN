#!/bin/bash

# Local Server 
lusr=$(eval "whoami")
lpass="ca903"
lhost="vpn.mikroskil.ac.id"


echo "============== Install and Update Package =============="
sshpass -p $lpass sudo apt update -y
sshpass -p $lpass sudo apt install openvpn openssh-server easy-rsa sshpass -y
echo "============== Create Easy-RSA =============="
mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
sshpass -p $lpass sudo chown $lusr ~/easy-rsa
chmod 700 ~/easy-rsa
echo "============== Create Server Certificates =============="
cd ~/easy-rsa
./easyrsa init-pki
echo "============== Create Vars Config =============="
echo 'set_var EASYRSA_REQ_COUNTRY   "ID"
set_var EASYRSA_REQ_PROVINCE        "SUMUT"
set_var EASYRSA_REQ_CITY            "Medan City"
set_var EASYRSA_REQ_ORG             "psi"
set_var EASYRSA_REQ_EMAIL           "psi@mikroskil.ac.id"
set_var EASYRSA_REQ_OU              "Community"
set_var EASYRSA_ALGO                "ec"
set_var EASYRSA_DIGEST              "sha512"' >> vars 
echo "============== BUILD CA =============="
EASYRSA_REQ_CN=$lhost ./easyrsa --batch build-ca nopass