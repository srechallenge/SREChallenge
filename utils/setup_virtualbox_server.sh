#! /bin/bash

#Bootstrap server vm

yum makecache
yum install -y git gzip perl nmap kernel-devel gcc wget PyYAML epel-release
yum install -y https://releases.hashicorp.com/vagrant/2.0.0/vagrant_2.0.0_x86_64.rpm
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | rpm --import -
curl http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo
yum install -y VirtualBox-5.1
yum install -y yum install kernel-devel-3.10.0-693.el7.x86_64 ansible
/sbin/vboxconfig
