##CentOS 6.5 install PHP 7.0 + MySQL 5.7 + Apache 2.4 + Nginx

1. ### Apache 2.4

Ref: 
```
https://www.centos.org/forums/viewtopic.php?t=57019
```
#### Step 1:
```
yum --enablerepo=extras install  centos-release-scl
```
#### Step 2:
```
yun install httpd24
```
#### Step 3:
```
[xxx$] cd /opt/rh/httpd24/root/usr/sbin/
[xxx$] ./httpd -version
[xxx$] ./apachectl start|stop|restart
```
NOTE: config files are in: /opt/rh/httpd24/root/etc/httpd

2. ### MySQL 5.7

Ref: 
```
http://www.tecmint.com/install-latest-mysql-on-rhel-centos-and-fedora/
http://dev.mysql.com/doc/refman/5.7/en/linux-installation-yum-repo.html
```
#### Step 1:
--------------- On RHEL/CentOS 6 ---------------
```
[xxx#] wget http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm
```

#### Step 2:
```
[xxx#] yum localinstall mysql57-community-release-el7-{version-number}.noarch.rpm
NOTE: use follow commands to check the result
yum repolist enabled | grep "mysql.*-community.*"
yum repolist all | grep mysql
yum-config-manager --enable mysql56-community
yum-config-manager --disable mysql57-community
yum repolist enabled | grep mysql
```

#### Step 3:
```
[xxx#] yum install mysql-community-server
```

1. ### PHP 7.0
Ref:
```
http://www.tecmint.com/install-apache-mysql-php-on-redhat-centos-fedora/
https://webtatic.com/projects/yum-repository/
```

#### Step 1: Update the repository
```
$ wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
$ wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
$ rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm
or can use this repository
https://ius.io/
```

#### Step 2: It is disabled by default, use the follow commands to check it
```
$ yum repolist disabled | grep remi
```

#### Step 3: Use the follow command to install/search it
```
$ sudo yum --enablerepo=remi search <keyword>
$ sudo yum --enablerepo=remi install <package-name>
$ sudo yum --enablerepo=remi install php70-php php70-php-common php70-php-fpm php70-php-cli php70-runtime php70-php-mbstring php70-php-mcrypt php70-php-mysqlnd php70-php-pdo php70-php-pear php70-php-pecl-mongodb php70-php-dba
```
#### Step 4: create the symbol links for php and php-fpm
```
$ ln -s /usr/bin/php70 /usr/bin/php
$ ln -s /opt/remi/php70/root/usr/sbin/php-fpm /usr/sbin/php-fpm
```

#### Step 5: check the installation
```$ php -v
$ php-fpm -v
$ php -i | less
$ ps aux | grep php-fpm
```

#### Step 6: check the config
```$ vim /etc/opt/remi/php70/php.ini
$ vim /etc/opt/remi/php70/php-fpm.d/www.conf
```
4. ### Nginx
Ref:
```
http://nginx.org/en/linux_packages.html#mainline

$ sudo yum --enablerepo=nginx install nginx
check port
$ netstat -lntp | grep nginx 

change the firewall configure
$ vim /etc/sysconfig/iptables <= -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
$ service iptables restart
or use follow command
$ system-config-firewall-tui
```