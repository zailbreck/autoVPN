#!/bin/bash


# Local Server 
lusr=$(eval "whoami")
lpass="vpn903"
lhost="vpn.mikroskil.ac.id"

# Remote Server
ruser="ca"
rpass="ca903"
rlhost=172.100.44.221

echo "============== Install and Update Package =============="
sshpass -p $lpass sudo apt update -y
sshpass -p $lpass sudo apt install openvpn openssh-server easy-rsa sshpass -y
sleep 5
echo "============== Create Easy-RSA =============="
mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
sshpass -p $lpass sudo chown $lusr ~/easy-rsa
sshpass -p $lpass sudo chmod 700 ~/easy-rsa
cd ~/easy-rsa
./easyrsa init-pki
sleep 5
echo "============== Create Server Certificates =============="
EASYRSA_REQ_CN=$lhost ./easyrsa --batch gen-req $lhost nopass
sshpass -p $lpass sudo cp /home/$lusr/easy-rsa/pki/private/$lhost.key /etc/openvpn/server/
sleep 5
echo "============== Copying Server Package to CA =============="
sshpass -p $lpass sudo scp /home/$lusr/easy-rsa/pki/reqs/$lhost.req $ruser@$rhost:/tmp
sshpass -p $lpass sudo scp /home/$lusr/autoVPN/setupCA.sh $ruser@$rhost:/tmp
sleep 5
echo "============== Run Remote Code Execution =============="
#ssh $ruser@$rhost ./tmp/setupCA.sh

echo "Setup OpenVPN Complete..."