#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

add-apt-repository -y ppa:ondrej/php

apt-get -y update && apt-get -y upgrade

apt-get install -y mysql-server mysql-client

apt-get -y install php7.1 apache2 libapache2-mod-php7.1
apt-get -y install php7.1-mysql php7.1-curl php7.1-dev php7.1-gd php7.1-intl php-pear php-imagick php7.1-imap php7.1-mcrypt php7.1-tidy php7.1-xmlrpc php7.1-xsl php7.1-mbstring php-gettext
apt-get -y install gcc make autoconf libc-dev pkg-config git zip build-essential curl
chown -R www-data:www-data /var/www/

# Errors are off by default - we don't want this
sudo sed -i.bak s/"display_errors = Off"/"display_errors = On"/g /etc/php/7.1/apache2/php.ini

# Install xdebug
wget https://xdebug.org/files/xdebug-2.5.1.tgz
tar -xzf xdebug-2.5.1.tgz
rm xdebug-2.5.1.tgz package.xml
cd xdebug-2.5.1/ && phpize && ./configure --enable-xdebug && make install && cd ../
rm -rf xdebug-2.5.1/

# XDebug enabling apache
echo '' | tee --append /etc/php/7.1/apache2/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' | tee --append /etc/php/7.1/apache2/php.ini
echo '; Added to enable Xdebug ;' | tee --append /etc/php/7.1/apache2/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' | tee --append /etc/php/7.1/apache2/php.ini
echo '' | tee --append /etc/php/7.1/apache2/php.ini
echo 'zend_extension="'$(find / -name 'xdebug.so' 2> /dev/null)'"' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.default_enable = 1' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.idekey = "vagrant"' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.remote_enable = 1' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.remote_autostart = 0' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.remote_port = 9000' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.remote_handler=dbgp' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' | tee --append /etc/php/7.1/apache2/php.ini
echo 'xdebug.remote_host=10.0.2.2 ; IDE-Environments IP, from vagrant box.' | tee --append /etc/php/7.1/apache2/php.ini

# XDebug enabling cli
echo '' | tee --append /etc/php/7.1/cli/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' | tee --append /etc/php/7.1/cli/php.ini
echo '; Added to enable Xdebug ;' | tee --append /etc/php/7.1/cli/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' | tee --append /etc/php/7.1/cli/php.ini
echo '' | tee --append /etc/php/7.1/cli/php.ini
echo 'zend_extension="'$(find / -name 'xdebug.so' 2> /dev/null)'"' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.default_enable = 1' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.idekey = "vagrant"' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.remote_enable = 1' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.remote_autostart = 0' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.remote_port = 9000' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.remote_handler=dbgp' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' | tee --append /etc/php/7.1/cli/php.ini
echo 'xdebug.remote_host=10.0.2.2 ; IDE-Environments IP, from vagrant box.' | tee --append /etc/php/7.1/cli/php.ini

# Copy over virtual host
cp /vagrant/vagrant/app.local.conf /etc/apache2/sites-available/app.local.conf

# Mods required
a2enmod rewrite
a2ensite app.local

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# Ready?
service apache2 restart