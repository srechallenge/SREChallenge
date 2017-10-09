# Vagrant deploy httpd for challenge


## Challenge
1. Create an instance of a web server that serves a static page via SSL with a redirect from 80 to 443
- I chose to use vagrant to build the webserver vm using the Ansible provisioner

2. Secure Server via a firewall to only expose ports 80 and 443
- There are two interfaces on the VM, eth0 which I consider a managemnet network has ssh enabled for administration, eth1 which is the public interface is allowing only ports 80 and 443 enabled.

3. Use an automated configuration management tool
- I used Ansible to perform the folowing
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
- I used serverspec for automated testing
  - Serverspec verfies each of the Ansible steps

## If I had more time to put into the challenge
- Modify the deployment to add the following
  - Front end haproxy nodes and an additional webserver node for HA
  - Monitoring software like nagios
  - Syslog forwarding to something like graylog

##Installed Software
###Host VM Installed Software
- VMWare Player CentOS vm with 8GB ram with 4 CPUs with the following software installed
  - sudo utils/setup_virtualbox_server.sh  
    - Vitualbox 5.1.28_117968
    - Ansible 2.3.2 (Can not use version 2.4 due to a bug with the Vagrant --ask_vault_pass flag)
    - Vagrant 2.0.0
    - nmap
  - sudo utils/setu_serverspec.sh
    - ruby
    - serverspec
  
## Web Server client VM
- Ansible 2.4.0

## How to run the deployment
1. Git clone the repo
- ```git clone https://github.com/srechallenge/SREChallenge.git```
2. cd into vagrant directory
- cd vagrant
3. Execute vagrant up
- vagrant up
- *Note*: You will be prompted for the vault password after Vagrant has created the VM prior to Ansible execution.
```
    default: Running ansible-playbook...
Vault password: 
```
- *Note*: At the end of the provision run, you will see a debug msg: Open Browser to http://192.168.1.57 (This IP will change)
....  This is will be the ip address that you need to browse to to get the Hello World! page.
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
5. Review the output for faulures
```
Finished in 4.02 seconds (files took 7.6 seconds to load)
31 examples, 0 failures
```

