##
# Cookbook Name:: vertica
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

package "vertica" do
	action :install
end

directory "/data/vertica" do
	mode "0755"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end

directory "/tmp/vtmp" do
	mode "0755"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end

directory "/data/etl_loading_dock" do
	mode "0777"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end

directory "/data/dbadmin/backup/" do
	mode "0755"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end

if(node.chef_environment == "uat")
	## This is assuming we have the standard m1.xlarge nodes for uat

	mdadm "/dev/md0" do
		level 0
		action [ :create, :assemble ]
		devices ["/dev/sdb","/dev/sdc","/dev/sdd","/dev/sde"]
	end

	mount "/data" do
		not_if "grep 'md0' /etc/mtab"
		device "/dev/md0"
		fstype "xfs"
		action [:mount, :enable]
	end

	directory "/data/Lockerz/" do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end

	directory "/data/Lockerz/data" do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end

	directory "/data/Lockerz/catalog" do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end

	directory "/data/db_dw/" do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end

	directory "/data/db_dw/data" do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end

	directory "/data/db_dw/catalog" do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end


	cookbook_file "/root/.ssh/id_rsa" do
		mode "0600"
		owner "root"
		group "root"
		source "id_rsa.uat"
	end

elsif(node.chef_environment == "prod")
	## Production uses the cc1.4xl nodes, which have two large
	##	ephemerial disks for data storage

	mdadm "/dev/md0" do
		level 0
		action [ :create, :assemble ]
		devices ["/dev/xvdc","/dev/xvdb"]
	end

	mount "/data" do
		#not_if "grep 'md0' /etc/mtab"
		device "/dev/md0"
		fstype "xfs"
		action [:mount, :enable]
	end

	if(node["vertica_primary"] == true)
		#puts "Primary vertica"
		execute "install chef" do
			not_if File.exists?( "/opt/vertica/config/users/dbadmin/installed.dat" )
			action :run
			command "/opt/vertica/sbin/install_vertica -z /root/vertica.install"
		end
	end

	cookbook_file "/root/.ssh/id_rsa" do
		mode "0600"
		owner "root"
		group "root"
		source "id_rsa.restore"
	end

	template "/root/vertica.install" do
		mode "0600"
		owner "root"
		group "root"
		source "vertica.install.erb"
		variables({
			:nodes => [
				"vertica-hvm0.dba.prod.lockerz.int",
				"vertica-hvm1.dba.prod.lockerz.int",
				"vertica-hvm2.dba.prod.lockerz.int"
			]
		})
	end

	template "/etc/hosts" do
		mode "0755"
		owner "root"
		group "root"
		source "vertica.hosts.erb"
		variables({
			:nodes => {
				#"vertica-hvm0.dba.prod.lockerz.int" => "10.17.152.231",
				#"vertica-hvm1.dba.prod.lockerz.int" => "10.17.150.201",
				#"vertica-hvm2.dba.prod.lockerz.int" => "10.17.147.42"
			}
		})
	end

	#cookbook_file "/opt/vertica/config/vbr.ini" do
		#mode "0600"
		#owner "root"
		#group "root"
		#source "vbr.ini"
	#end

end

execute "fix vertica perms" do
	action :run
	command "chown -R dbadmin:dbadmin /opt/vertica/ ; chown -R dbadmin:dbadmin /data"
end

#["config","config/share","log","scripts"].each do |dirName|
	#directory "/opt/vertica/%s" % dirName do
		#mode "0755"
		#owner "dbadmin"
		#group "dbadmin"
		#recursive true
	#end
#end

#cookbook_file "/opt/vertica/config/share/license.key" do
	#mode "0665"
	#owner "dbadmin"
	#group "dbadmin"
	#source "license.key"
#end


#verticaNodes = search( :node,"run_list:role\\[VerticaClusterNode\\] AND chef_environment:%s" % node.chef_environment )
#template "/opt/vertica/config/vspread.conf" do
	#mode "0665"
	#owner "dbadmin"
	#group "dbadmin"
	#source "vspread.conf.erb"
	#variables({
		#:nodes => verticaNodes
	#})
#end

#service "vertica" do
	#action [ :enable, :start ]
	#supports :restart => true, :reload => true
	#ignore_failure true
#end

cookbook_file "/root/lockerz.vertica.dat" do
	mode "0666"
	owner "root"
	group "root"
	source "lockerz.vertica.dat"
end

#cookbook_file "/root/vertica.install" do
	#mode "0666"
	#owner "root"
	#group "root"
	#source "vertica.install"
#end

cookbook_file "/opt/vertica/bin/verticaInstall.py" do
	mode "0666"
	owner "root"
	group "root"
	source "verticaInstall.py"
end

cookbook_file "/root/vertica-5.0.4-0.x86_64.RHEL5.rpm" do
	mode "0666"
	owner "root"
	group "root"
	source "vertica-5.0.4-0.x86_64.RHEL5.rpm"
end

cookbook_file "/etc/security/limits.conf" do
	mode "0666"
	owner "root"
	group "root"
	source "limits.conf"
end

cookbook_file "/etc/sysctl.conf" do
	mode "0766"
	owner "root"
	group "root"
	source "sysctl.conf"
end

cookbook_file "/etc/rc.local" do
	mode "0666"
	owner "root"
	group "root"
	source "rc.local"
end

cookbook_file "/root/.bashrc" do
	mode "0666"
	owner "root"
	group "root"
	source "bashrc"
end
