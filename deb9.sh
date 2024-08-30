#!/bin/bash
# Illegal selling and redistribution of this script is strictly prohibited.
# Please respect author's property.
# Binigay sainyo ng libre, ipamahagi nyo rin ng libre.

# Step 1: Remove previous DebianVPS installer files if present
rm -f DebianVPS* 

# Step 2: Download and run the DebianVPS installer
wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/DebianVPS-Installer' 
chmod +x DebianVPS-Installer 
./DebianVPS-Installer

# Step 3: Remove existing banner and set a new one
rm -f /etc/banner
wget -qO /etc/banner https://raw.githubusercontent.com/bannerpy/Files/main/mcbanner
dos2unix -q /etc/banner

# Step 4: Restart SSH and Dropbear services
service ssh restart
service sshd restart
service dropbear restart

# Step 5: Download and set up MicroSSH proxy template
wget -q -O /etc/microssh https://raw.githubusercontent.com/bannerpy/Files/main/micro.py
chmod +x /etc/microssh

# Step 6: Create and enable MicroSSH systemd service
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

# Reload systemd to recognize the new service
systemctl daemon-reload
systemctl enable microssh
systemctl restart microssh

# Step 7: Install Squid and configure it
apt-get install -y squid squid3
wget -qO /etc/squid/squid.conf https://raw.githubusercontent.com/Senpaiconfig/microsshpanel/main/squid.conf
dos2unix -q /etc/squid/squid.conf
service squid restart

# Echo message to indicate Squid fix applied
echo "Squid configuration applied successfully."

# Step 8: Apply OpenVPN fix
bash -c "sed -i '/ncp-disable/d' /etc/openvpn/server/*.conf; systemctl restart openvpn-server@{ec_s,s}erver_{tc,ud}p"

# Echo message to indicate OpenVPN fix applied
echo "OpenVPN configuration fix applied successfully."

# Step 9: Start and restart Stunnel4 service
service stunnel4 start
service stunnel4 restart

# Step 10: Update the system
sudo apt update

# Step 11: Cleanup logs and history
echo "" > ~/.bash_history 
echo '' > /var/log/syslog

# Step 12: Remove crontab file
rm -f /etc/crontab

# Step 13: Clear bash history and display a final message
history -c
clear

echo "MICROSSH AUTO SCRIPT INSTALLATION COMPLETED"
