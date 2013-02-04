
if(node[:platform] == "ubuntu")

  # Create zabbix group
  group node['zabbix']['login'] do
    gid node['zabbix']['gid']
    if node['zabbix']['gid'].nil? 
      action :nothing
    else
      action :create
    end
  end

  # Create zabbix User
  user node['zabbix']['login'] do
    comment "zabbix User"
    home node['zabbix']['install_dir']
    shell node['zabbix']['shell']
    uid node['zabbix']['uid']
    gid node['zabbix']['gid'] 
  end

  # Define zabbix agent folders
  root_dirs = [
    # node['zabbix']['etc_dir'],
    node['zabbix']['install_dir'],
    "#{node['zabbix']['install_dir']}/bin",
    "#{node['zabbix']['install_dir']}/sbin",
    "#{node['zabbix']['install_dir']}/share"
  ]

  # Create root folders
  root_dirs.each do |dir|
    directory dir do
      owner "zabbix"
      group "zabbix"
      mode "755"
      recursive true
    end
  end

  # Define zabbix log and run folders
  zabbix_dirs = [
    node['zabbix']['log_dir'],
    node['zabbix']['run_dir']
  ]

  # Create zabbix folders
  zabbix_dirs.each do |dir|
    directory dir do
      owner node['zabbix']['login']
      group node['zabbix']['group']
      mode "755"
      recursive true
      # Only execute this if zabbix can't write to it. This handles cases of
      # dir being world writable (like /tmp)
      # [ File.word_writable? doesn't appear until Ruby 1.9.x ]
      not_if "su #{node['zabbix']['login']} -c \"test -d #{dir} && test -w #{dir}\""
    end
  end

# Define zabbix upstart service
  service "zabbix-agent" do
      provider Chef::Provider::Service::Upstart
      # action [ :enable, :start ]
      supports :restart => true, :reload => true
      ignore_failure true
  end

# Zabbix upstart script
  cookbook_file "/etc/init/zabbix-agent.conf" do
     mode "0644"
     owner "zabbix"
     group "zabbix"
     source "zabbix/zabbix-agent.conf"
  end

  cookbook_file "/opt/zabbix/bin/zabbix_sender" do
     mode "0755"
     owner "zabbix"
     group "zabbix"
     source "zabbix/zabbix_sender"
  end

  cookbook_file "/opt/zabbix/bin/zabbix_get" do
     mode "0755"
     owner "zabbix"
     group "zabbix"
     source "zabbix/zabbix_get"
  end

# Zabbix config - specifies zabbix server ip 
  cookbook_file "/usr/local/etc/zabbix_agentd.conf" do
     mode "0644"
     owner "zabbix"
     group "zabbix"
     source "zabbix/zabbix_agentd.conf"
  end

# Zabbix binaries 
  cookbook_file "/opt/zabbix/sbin/zabbix_agentd" do
     mode "0755"
     owner "zabbix"
     group "zabbix"
     source "zabbix/zabbix_agentd"
     notifies :restart, resources(:service => "zabbix-agent")
  end

end
