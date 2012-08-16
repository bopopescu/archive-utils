#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Configure newrelic repo
# Centos
execute "create-yum-cache" do
  command "yum -q makecache"
  action :nothing
end

ruby_block "reload-internal-yum-cache" do
  block do
    Chef::Provider::Package::Yum::YumCache.instance.reload
  end
  action :nothing
end

cookbook_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-NewRelic" do
  source "RPM-GPG-KEY-NewRelic"
  mode "0644"
  only_if { node[:platform] == "centos" }
end

cookbook_file "/etc/yum.repos.d/newrelic.repo" do
  source "newrelic.repo"
  mode "0644"
  notifies :run, resources(:execute => "create-yum-cache"), :immediately
  notifies :create, resources(:ruby_block => "reload-internal-yum-cache"), :immediately
  only_if { node[:platform] == "centos" }
end

# Ubuntu
bash "enable_newrelic_repo" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  /usr/bin/wget -O - http://download.newrelic.com/548C16BF.gpg | /usr/bin/apt-key add -
  /usr/bin/apt-get update
  EOH
  action :nothing
end

cookbook_file "/etc/apt/sources.list.d/newrelic.list" do
  source "newrelic.list"
  mode "0444"
  only_if { node[:platform] == "ubuntu" }
  notifies :run, resources(:bash => "enable_newrelic_repo"), :immediately
end



package "newrelic-php5"
# /usr/bin/newrelic-install install

cookbook_file "/etc/newrelic/newrelic.cfg" do
  source "newrelic.cfg"
  mode 400
end

# install the system monitor daemon
package "newrelic-sysmond" do
  action :install
end

# configure it
execute "/usr/sbin/nrsysmond-config --set license_key=a2364edea940fa99e5495b46ab291b62c3ef437b"

# and start it up
service "newrelic-sysmond" do
  action [ :enable, :start ]
  supports :restart => true, :reload => true
  ignore_failure true
end

