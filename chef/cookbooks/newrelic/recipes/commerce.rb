#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "newrelic::default"

template "/etc/php.d/newrelic.ini" do
  source "newrelic_ini.erb"
  variables({
    :app_name => "Commerce",
    :framework => "magento"
  })
end

service "httpd" do
    supports :status => true, :restart => true, :reload => true
    action :restart
end

service "newrelic-daemon" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end

