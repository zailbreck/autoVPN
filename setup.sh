#!/bin/bash


# Local Server 
usr=$(eval "whoami")
rpass="vpn903"
host="vpn.mikroskil.ac.id"

# Remote Server
luser="ca"
lpass="ca903"
lhost=172.100.44.221

echo "============== Install and Update Package =============="
sshpass -p $rpass sudo apt update -y
sshpass -p $rpass sudo apt install openvpn openssh-server easy-rsa sshpass -y
echo "============== Create Easy-RSA =============="
mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
sshpass -p $rpass sudo chown $usr ~/easy-rsa
chmod 700 ~/easy-rsa
echo "============== Create Server Certificates =============="
cd ~/easy-rsa
EASYRSA_REQ_CN=$host ./easyrsa --batch gen-req $host nopass
sshpass -p $rpass sudo cp /home/$usr/easy-rsa/pki/private/$host.key /etc/openvpn/server/
echo "============== Copying Server Package to CA =============="
sshpass -p $rpass sudo scp /home/$usr/easy-rsa/pki/reqs/$host.req $luser@$lhost:/tmp
sshpass -p $rpass sudo scp /home/$usr/setupCA.sh $luser@$lhost:/tmp

echo "============== Run Remote Code Execution =============="
ssh $luser@$lhost ./tmp/setupCA.sh

echo "Setup OpenVPN Complete..."