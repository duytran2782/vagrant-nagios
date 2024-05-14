#!/bin/bash

# Update the system
sudo yum -y update

# Install required packages
sudo yum -y install mailx cyrus-imapd cyrus-sasl cyrus-sasl-plain httpd php gcc glibc glibc-common gd gd-devel make net-snmp unzip openssl openssl-devel

# Open port 80 in order to connect
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload
# sudo firewall-cmd --list-all

# Download and install Nagios 4.4.2
cd /usr/src/
sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.2.tar.gz
sudo tar zxf nagios-*.tar.gz
cd nagioscore-nagios-*/
sudo ./configure
sudo make all
sudo make install-groups-users
sudo usermod -a -G nagios apache

sudo make install
sudo make install-commandmode
sudo make install-config
sudo make install-webconf

sudo make install-daemoninit

# Set Nagios admin password || sometimes need to run manual just 1 param username
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin 123

# Restart httpd
sudo systemctl restart httpd
sudo systemctl enable httpd

# Install Plugin
cd /usr/src/

sudo wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
sudo tar zxf nagios-plugins.tar.gz
cd nagios-plugins-release-2.2.1
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install

# Start nagios
sudo systemctl start nagios
sudo systemctl status nagios

sudo getenforce
sudo setenforce 0

sudo systemctl restart nagios httpd

# Install NRPE
# downloading the Source
sudo -i

cd /tmp
wget --no-check-certificate -O nrpe.tar.gz https://github.com/NagiosEnterprises/nrpe/archive/nrpe-4.1.0.tar.gz
tar xzf nrpe.tar.gz

# compile
cd /tmp/nrpe-nrpe-4.1.0/
./configure --enable-command-args
make all

# create User And Group
make install-groups-users

# installs the binary files, the NRPE daemon and the check_nrpe plugin
make install
make install-config

# update Services File
echo >> /etc/services
echo '# Nagios services' >> /etc/services
echo 'nrpe    5666/tcp' >> /etc/services

make install-init
systemctl enable nrpe.service

firewall-cmd --zone=public --add-port=5666/tcp
firewall-cmd --zone=public --add-port=5666/tcp --permanent

sed -i '/^allowed_hosts=/s/$/,10.10.10.11,10.10.10.12/' /usr/local/nagios/etc/nrpe.cfg
sed -i 's/^dont_blame_nrpe=.*/dont_blame_nrpe=1/g' /usr/local/nagios/etc/nrpe.cfg

systemctl start nrpe.service
