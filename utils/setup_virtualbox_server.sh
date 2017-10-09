#! /bin/bash

#Bootstrap server vm
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | rpm --import -
curl http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo
yum makecache
yum install -y git gunzip perl nmap kernel-devel gcc
yum install -y https://releases.hashicorp.com/vagrant/2.0.0/vagrant_2.0.0_x86_64.rpm
yum install -y VirtualBox-5.1
