#!/bin/bash

# Local Server  (VPN Server)
lusr=$(eval "whoami")
lpass="vpn903"
lhost="vpn.mikroskil.ac.id"

# Remote Server (CA Server)
ruser="ca"
rpass="ca903"
rlhost=172.100.44.221

echo "[Local] Install and Update Package ..."
sshpass -p $lpass sudo apt update -y
sshpass -p $lpass sudo apt install openvpn openssh-server easy-rsa sshpass -y
echo "========================================="
sleep 1
echo "[Local] Creatin Easy-RSA ..."
mkdir ~/autoVPN/easy-rsa
ln -s /usr/share/easy-rsa/* ~/autoVPN/easy-rsa
sshpass -p $lpass sudo chown $lusr ~/autoVPN
sshpass -p $lpass sudo chmod 700 ~/autoVPN
cd ~/autoVPN/easy-rsa
./easyrsa init-pki
echo "========================================="
sleep 1
echo "[Local] Generate Server Certificate ..."
EASYRSA_REQ_CN=$lhost ./easyrsa --batch gen-req $lhost nopass
sshpass -p $lpass sudo cp /home/$lusr/autoVPN/easy-rsa/pki/private/$lhost.key /etc/openvpn/server/
echo "========================================="
sleep 1
echo "============== Copying Server Package to CA =============="
sshpass -p $lpass sudo scp /home/$lusr/autoVPN/easy-rsa/pki/reqs/$lhost.req $ruser@$rhost:/tmp
echo "========================================="
sleep 1
echo "============== Run Remote Code Execution =============="
sshpass -p $rpass ssh $ruser@$rhost "cd ~/autoVPN/CA/ ; ./setupCA.sh"
echo "========================================="

echo "Setup OpenVPN Complete..."