require 'spec_helper'

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('ansible'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe command('systemctl status rpcbind'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /masked/ }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('firewalld'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe command('firewall-cmd --zone=public --list-services'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match "https http\n" }
end

describe command('firewall-cmd --get-active-zones | grep -A1 public'), :if => os[:family] == 'redhat' do
  its(:stdout) { should contain "eth1" }
end

describe command('firewall-cmd --get-active-zones | grep -A1 internal'), :if => os[:family] == 'redhat' do
  its(:stdout) { should contain "eth0" }
end

describe file('/etc/pki/tls/private/webserver.com.key') do
  it { should be_file }
end

describe file('/etc/pki/tls/private/webserver.com.csr') do
  it { should be_file }
end

describe file('/etc/pki/tls/certs/webserver.com.crt') do
  it { should be_file }
end

describe file('/etc/httpd/conf.d/autoindex.conf') do
  it { should_not be_file }
end

describe file('/etc/httpd/conf.d/README') do
  it { should_not be_file }
end

describe file('/etc/httpd/conf.d/userdir.conf') do
  it { should_not be_file }
end

describe file('/etc/httpd/conf.d/welcome.conf') do
  it { should_not be_file }
end

describe file('/var/www/html/index.html') do
  it { should be_file }
end

describe file('/var/www/html/index.html') do
  its(:content) { should match /Hello World!/ }
end

describe file('/etc/httpd/conf.d/ssl.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file('/etc/httpd/conf/httpd.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe port(80) do
  it { should be_listening.with('tcp') }
end

describe port(443) do
  it { should be_listening.with('tcp') }
end

describe command('curl http://`ip addr show eth1 |grep "inet " | awk \'{print $2}\' | cut -d/ -f1`'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /302/ }
end

describe command('curl -kL http://`ip addr show eth1 |grep "inet " | awk \'{print $2}\' | cut -d/ -f1`'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /Hello World!/ }
end