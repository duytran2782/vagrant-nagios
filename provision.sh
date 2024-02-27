#!/bin/bash

# Update the system
sudo yum -y update

# Install required packages
sudo yum -y install httpd mailx cyrus-imapd cyrus-sasl cyrus-sasl-plain php gcc glibc glibc-common gd gd-devel make net-snmp unzip

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

sudo systemctl restart httpd

sudo make install-daemoninit

# Set Nagios admin password
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
sudo make insta

# Start nagios
sudo systemctl start nagios
sudo systemctl status nagios

sudo getenforce
sudo setenforce 0
sudo service nagios restart
