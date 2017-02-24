#!/bin/bash
##################
#
# Scaffolds the staging / dev folders and creates the VHOSTS
#
# ---- How To Run-----
# sudo bash bootstrap.sh 1234-website domain.com public
# Where "public" is the desired server root
#---------------------
#
# Author: Grant Kimball
# Company: YourLocalWebmaster.com
##############################
#Colors
RED='\033[0;31m' #red color
BLUE='\033[0;34m' #blue color
WHITE='\033[1;37m' # WHITE color
YELLOW='\033[1;33m' # YELlOW
NC='\033[0m' #no color

APACHE_LOG_DIR=/var/log/apache2

if [$1 == '']; then
	echo "\n${RED}Please set a vhost param. i.e. bootstrap.sh 1234-mysite mydomain.com\n"
	 exit
fi
if [$2 == '']; then
	echo "\n${RED}Please set a domain param. i.e. bootstrap.sh 1234-mysite mydomain.com\n"
	 exit
fi
root=$3
new_v_host=$1
new_vhost_domain=$2

dev_path=/var/www/dev/$new_v_host
staging_path=/var/www/staging/$new_v_host

echo  "\n${RED}You would like me to create the virtual directory for: $new_v_host.$new_vhost_domain\n"
echo "\n${WHITE}This will park your DEV ROOT at ${YELLOW}${dev_path}${NC}/${RED}${root}${NC}\n"
echo "\n${WHITE}This will park your STAGING ROOT at ${YELLOW}${staging_path}${NC}/${RED}${root}${NC}\n${NC}"

echo "${YELLOW}"
while true; do
    read -p "Does the above look correct to you? " yn
    case $yn in
        [Yy]* ) echo "Great! Let's do this!"; break;;
        [Nn]* ) echo " OK, please try again."; exit;;
        * ) echo "Please answer yes or no. ";;
    esac
done
echo "${NC}"

#Created dev file structure
echo  "\n${RED}Creating $dev_path\n${NC}"
mkdir -p $dev_path/$root; cd $dev_path/$root
echo "<?php phpinfo();?>" >> index.php
echo "\n${BLUE}Dev structure complete.${NC}\n"
#Created file structure

chown -R ubuntu:www-data $dev_path/$root
chmod -R 775 $dev_path/$root

#Creating staging file structure
echo  "\n${RED}Creating $staging_path${NC}\n"
mkdir -p $staging_path/$root; cd $staging_path/$root
echo "<?php phpinfo(); ?>" >> index.html
echo "\n${BLUE}Staging structure complete.\n${NC}"

chown -R ubuntu:www-data $staging_path/$root
chmod -R 775 $staging_path/$root

#Creating VHOSTS

echo "\n${BLUE}Creating Virtual Hosts for dev.$new_v_host.$new_vhost_domain${NC}\n"
devvhost=/etc/apache2/sites-available/dev.$new_v_host.$new_vhost_domain.conf
echo "<VirtualHost *:80>" >> $devvhost
echo "ServerName dev.$new_v_host.$new_vhost_domain" >> $devvhost
echo "ServerAdmin webmaster@localhost" >> $devvhost
echo "DocumentRoot ${dev_path}/${root}" >> $devvhost
echo "ErrorLog ${APACHE_LOG_DIR}/dev.$new_v_host.error.log" >> $devvhost
echo "CustomLog ${APACHE_LOG_DIR}/dev.$new_v_host.access.log combined" >> $devvhost
echo "</VirtualHost>" >> $devvhost

echo "\n${RED} Vhost created ${NC}\n"

echo "\n${BLUE}Creating Virtual Hosts for staging.$new_v_host.$new_vhost_domain\n${NC}"

stagingvhost=/etc/apache2/sites-available/staging.$new_v_host.$new_vhost_domain.conf
echo "<VirtualHost *:80> " >> $stagingvhost
echo "ServerName staging.$new_v_host.$new_vhost_domain" >> $stagingvhost
echo "ServerAdmin webmaster@localhost" >> $stagingvhost
echo "DocumentRoot ${staging_path}/${root}" >> $stagingvhost
echo "ErrorLog ${APACHE_LOG_DIR}/staging.$new_v_host.$new_vhost_domain.error.log" >> $stagingvhost
echo "CustomLog ${APACHE_LOG_DIR}/staging.$new_v_host.$new_vhost_domain.access.log combined" >> $stagingvhost
echo "</VirtualHost>" >> $stagingvhost

echo "\n${RED} Vhost created ${NC}\n"




echo "${WHITE}\nAlright guy, here goes nothing.. enabling sites and restarting apache... \n${NC}"

a2ensite dev.$new_v_host.$new_vhost_domain.conf
a2ensite staging.$new_v_host.$new_vhost_domain.conf

service apache2 restart

echo "${WHITE}The following urls should now be active: {NC}\n"

echo "${RED} dev.$new_v_host.$new_vhost_domain\n"
echo "${RED} staging.$new_v_host.$new_vhost_domain\n"