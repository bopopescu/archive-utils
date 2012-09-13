#
# Cookbook Name:: ohai_plugins
# Recipe:: dpkg
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "#{node['ohai']['plugin_path']}/dpkg.rb" do
  source "plugins/dpkg.rb"
  owner "root"
  group "root"
  mode 0755
end

include_recipe "ohai"
