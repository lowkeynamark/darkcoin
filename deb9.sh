# Illegal selling and redistribution of this script is strictly prohibited.
# Please respect author's property.
# Binigay sainyo ng libre, ipamahagi nyo rin ng libre.
#
#


# Step 2: Install AutoScript and configure SSH
function install_autoscript() {
    rm -f DebianVPS* 
    wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/DebianVPS-Installer' 
    chmod +x DebianVPS-Installer 
    ./DebianVPS-Installer
    rm -f /etc/banner
    wget -qO /etc/banner https://raw.githubusercontent.com/bannerpy/Files/main/mcbanner
    dos2unix -q /etc/banner
    service ssh restart
    service sshd restart
    service dropbear restart
}
install_autoscript

# Step 3: Get proxy template
function setup_proxy_template() {
    wget -q -O /etc/microssh https://raw.githubusercontent.com/bannerpy/Files/main/micro.py
    chmod +x /etc/microssh
}
setup_proxy_template

# Step 4: Install and configure microssh service
function install_microssh_service() {
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
install_microssh_service

sleep 3s
clear

# Step 5: Update microssh configuration and start service
function configure_microssh() {
    sed -i "/DEFAULT_HOST = '127.0.0.1:443'/c\DEFAULT_HOST = '127.0.0.1:550'" /etc/microssh
    systemctl daemon-reload
    systemctl enable microssh
    systemctl restart microssh
}
configure_microssh

sleep 1s

# Step 6: Install Squid
apt-get install -y squid squid3

# Step 7: Configure Squid
function configure_squid() {
    wget -qO /etc/squid/squid.conf https://raw.githubusercontent.com/Senpaiconfig/microsshpanel/main/squid.conf
    dos2unix -q /etc/squid/squid.conf
}
configure_squid

# Step 8: Fix OpenVPN configuration
function fix_openvpn() {
    bash -c "sed -i '/ncp-disable/d' /etc/openvpn/server/*.conf; systemctl restart openvpn-server@{ec_s,s}erver_{tc,ud}p"
}
fix_openvpn

# Step 9: Update the script and restart services
service stunnel4 start
service stunnel4 restart
sudo apt update

# Step 10: Cleanup logs and history
function cleanup() {
    echo "" > .bash_history 
    echo '' > /var/log/syslog
}
cleanup

sleep 2s

# Step 11: Remove crontab files
rm -f /etc/crontab

sleep 2s

# Step 12: Clear history and display message
history -c
clear

echo "MICROSSH AUTO SCRIPT"
