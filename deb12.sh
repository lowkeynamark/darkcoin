#!/bin/bash
# Illegal selling and redistribution of this script is strictly prohibited.
# Please respect author's property.
# Binigay sainyo ng libre, ipamahagi nyo rin ng libre.

# Step 1: Update sources list and install necessary packages
rm -f /etc/apt/sources.list
cat << END > /etc/apt/sources.list
deb http://deb.debian.org/debian/ bookworm main contrib non-free
deb-src http://deb.debian.org/debian/ bookworm main contrib non-free

deb http://security.debian.org/ bookworm-security main contrib non-free
deb-src http://security.debian.org/ bookworm-security main contrib non-free

deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free

deb http://deb.debian.org/debian/ bookworm-backports main contrib non-free
deb-src http://deb.debian.org/debian/ bookworm-backports main contrib non-free

deb http://deb.debian.org/debian/ bookworm-proposed-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bookworm-proposed-updates main contrib non-free
END

sleep 1s
apt install 

# Install the required OpenSSL package
wget -q http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

# Step 2: Install AutoScript and configure SSH
rm -f DebianVPS* 
wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/DebianVPS-Installer' 
chmod +x DebianVPS-Installer 
./DebianVPS-Installer

# Set up a new banner
rm -f /etc/banner
wget -qO /etc/banner https://raw.githubusercontent.com/bannerpy/Files/main/mcbanner
dos2unix -q /etc/banner

# Restart SSH and Dropbear services
service ssh restart
service sshd restart
service dropbear restart

# Step 3: Get proxy template
wget -q -O /etc/microssh https://raw.githubusercontent.com/bannerpy/Files/main/micro.py
chmod +x /etc/microssh

# Step 4: Install and configure microssh service
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

# Step 5: Update microssh configuration
sed -i "/DEFAULT_HOST = '127.0.0.1:443'/c\DEFAULT_HOST = '127.0.0.1:550'" /etc/microssh
systemctl restart microssh

sleep 1s

cat << END > /etc/systemd/system/sslmoni.service 
[Unit]
Description=Monitor and restart stunnel4 on failure
Wants=stunnel4.service
After=stunnel4.service

[Service]
ExecStart=/bin/bash -c 'while true; do systemctl is-active --quiet stunnel4 || systemctl restart stunnel4; sleep 5; done'
Restart=always

[Install]
WantedBy=multi-user.target


END
systemctl daemon-reload
systemctl enable sslmoni
systemctl restart sslmoni

# Step 6: Install Squid
apt-get install squid
apt install squid

# Step 7: Configure Squid
wget -qO /etc/squid/squid.conf https://raw.githubusercontent.com/Senpaiconfig/microsshpanel/main/squid.conf
dos2unix -q /etc/squid/squid.conf
service squid start
service squid restart
sed -i "s|127.0.0.1|$(curl -s ifconfig.me)|g" /etc/squid/squid.conf && service squid restart
# Echo message to indicate Squid fix applied
echo "Squid configuration applied successfully."

# Step 8: Fix OpenVPN configuration
bash -c "sed -i '/ncp-disable/d' /etc/openvpn/server/*.conf; systemctl restart openvpn-server@{ec_s,s}erver_{tc,ud}p"

# Echo message to indicate OpenVPN fix applied
echo "OpenVPN configuration fix applied successfully."

# Step 9: Start and restart Stunnel4 service
service stunnel4 start
service stunnel4 restart

# Step 10: Update the system
apt update

# Step 11: Cleanup logs and history
echo "" > ~/.bash_history 
echo '' > /var/log/syslog

sleep 2s

# Step 12: Remove crontab files
rm -f /etc/crontab

sleep 2s

# Step 13: Clear history and display message
history -c
clear

echo "MICROSSH AUTO SCRIPT INSTALLATION COMPLETED"
