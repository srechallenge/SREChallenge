# Vagrant deploy httpd for challenge


## Challenge
1. Create an instance of a web server that serves a static page via SSL with a redirect from 80 to 443
- I chose to use vagrant to build the webserver vm using the Ansible provisioner

2. Secure Server via a firewall to only expose ports 80 and 443
- There are two interfaces on the VM, eth0 which I consider a managemnet network has ssh enabled for administration, eth1 which is the public interface is allowing only ports 80 and 443 enabled.

3. Use an automated configuration management tool
- Ansible was used to perform the folowing
  - Start and enable firwalld
  - Move eth0 to the internal firewall zone
  - Remove ssh from the public firewall zone
  - Add http and https to the public firewall zone
  - Install the httpd and mod_ssl rpms
  - Update the /etc/httpd/conf/http.conf file
  - Remove the default /etc/httpd/conf.d/ entries
  - Add the /etc/httpd/conf.d/ssl.conf file
  - Add the /var/www/html/index.html with the Hello World content
  - Copy the certificate files into place
  - Spit out the Public IP address to connect to

4. Develop and apply automated tests to verify correctness of the server configuration.
- Serverspec was used to verify the server configuration

## If I had more time to put into the challenge
- Modify the deployment to add the following
  - Create a haproxy cluster which Serves SSL and hosts the re-direct from http to https
    - Move the web server behind the haproxy cluster, and add an additional web server node
  - Monitoring software like nagios
    - To monitor the server
    - To monitor the web service is up and serving content
  - Syslog forwarding to something like graylog
    - To forward all of the system and application logs to the graylog server for engineers to use for operations and security related events
  - Harden the web server further
  - Clean up the httpd config it works but I am not happy with it

## Installed Software
### Host VM Installed Software
- VMWare Player CentOS vm with 8GB ram with 4 CPUs with the following software installed
  - setup_virtualbox_server.sh  - which installs the following software
    - Vitualbox 5.1.28_117968
    - Ansible 2.3.2 (Can not use version 2.4 due to a bug with the Vagrant --ask_vault_pass flag)
    - Vagrant 2.0.0
    - nmap
    - runs the vboxconfigure command to build the kernel modules
  - setup_serverspec.sh
    - ruby
    - serverspec
  - setup_GUI.sh (If you want to use a GUI on your virtualbox server vm)
    - *Requires the vmware tools to be installed on the virtualbox server*
    - xorg
    - Gnome Desktop
  
## Web Server client VM
- Ansible 2.4.0 (This is installed during the vagrant up run)

## Setup the virtualbox host VM ( Used to build the vmware virtualbox host vm the webserver vm will be created on )
1. Built VM Base vm from CentOS-7-x86_64-Minimal-1708.iso - 8GB Ram, 4CPU, 20GB disk at least
2. Install git 
- ```yum install -y git```
3. Git clone the repo
- ```git clone https://github.com/srechallenge/SREChallenge.git```
4. Run setup_virtualbox_server.sh script - installs virtualbox and other requirements
- ``` sudo utils/setup_virtualbox_server.sh ```
5. Run setup_serverspec.sh - sets up ruby and serverspec
- ``` sudo utils/setup_serverspec.sh ```

## How to run the webserver deployment
- *Assumptions for virtualbox server host* 
  - Virtualbox 5.1 installed
  - Ansible 2.3.2 installed
  - serverspec installed
  - Vagrant 2.0.0 installed
1. Git clone the repo
- ```git clone https://github.com/srechallenge/SREChallenge.git```
2. cd into vagrant directory
- ``` cd vagrant ```
3. Execute vagrant up
-  ``` vagrant up ```
- *Note*: You will be prompted for the vault password after Vagrant has created the VM prior to Ansible execution.
```
    default: Running ansible-playbook...
Vault password: 
```
- *Note*: At the end of the provision run, you will see a debug msg: Open Browser to http://192.168.1.57 (This IP will change)
  - This is will be the ip address that you need to browse to to get the Hello World! page.
```
TASK [debug] *******************************************************************
ok: [webserver] => {
    "msg": "Open Browser to http://192.168.1.60"
}
PLAY RECAP *********************************************************************
webserver                  : ok=15   changed=13   unreachable=0    failed=0   
```
4. Execute serverspec tests
- From the vagrant directory run the serverspec tests
-- ../utils/run_tests.sh
5. Verify Open Ports
- nmap (IP address at the bottom of step 3)
```
[user@localhost vagrant]$ nmap 192.168.1.60

Starting Nmap 6.40 ( http://nmap.org ) at 2017-10-08 22:19 EDT
Nmap scan report for 192.168.1.60
Host is up (0.98s latency).
Not shown: 998 filtered ports
PORT    STATE SERVICE
80/tcp  open  http
443/tcp open  https

Nmap done: 1 IP address (1 host up) scanned in 51.60 seconds
[user@localhost vagrant]$ 
 ```
6. Review the output for faulures
```
Command "curl http://`ip addr show eth1 |grep "inet " | awk '{print $2}' | cut -d/ -f1`"
  stdout
    should match /302/

Command "curl -kL http://`ip addr show eth1 |grep "inet " | awk '{print $2}' | cut -d/ -f1`"
  stdout
    should match /Hello World!/

Finished in 3.98 seconds (files took 7.85 seconds to load)
31 examples, 0 failures

[user@localhost vagrant]$ 

```

