##
# Default vertica layout
#
#	This should be limited to creating any default containers, files, and resources common to all vertica nodes.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

## Packages
package "vertica"

package "autofs" do
	action :remove
end


## Use the m1.xlarge profile
# 	* /dev/md0 -> /dev/sd[b,c,d,e]
#	* mount /dev/md0 to /data
if(node["ec2"]["instance_type"] == "m1.xlarge")

	mdadm "/dev/md0" do
		level 0
		action [ :create, :assemble ]
		devices ["/dev/sdb","/dev/sdc","/dev/sdd","/dev/sde"]
	end

	mount "/data" do
		not_if "grep 'md0' /etc/mtab"
		device "/dev/md0"
		fstype "xfs"
	end
end

## Use the cc1.4xlarge cluster compute layout
#	/dev/md0 -> /dev/xvd[b,c]
#	mount /dev/md0 to /data
if(node["ec2"]["instance_type"] == "cc1.4xlarge")
	mdadm "/dev/md0" do
		level 0
		action [ :create, :assemble ]
		devices ["/dev/xvdc","/dev/xvdb"]
	end

	service "autofs" do
		action :disable
	end

	mount "/data" do
		device "/dev/md0"
		fstype "xfs"
	end
end



## Special hooks to make uat work right.
#	@TODO: move this to uat.rb
if(node.chef_environment == "uat")
	cookbook_file "/root/.ssh/id_rsa" do
		mode "0600"
		owner "root"
		group "root"
		source "id_rsa.uat"
	end

	template "/root/vertica.install" do
		mode "0600"
		owner "root"
		group "root"
		source "vertica.install.erb"
		variables({
			:nodes => [
				"vertica0.dba.uat.lockerz.int",
				"vertica1.dba.uat.lockerz.int",
				"vertica2.dba.uat.lockerz.int"
			]
		})
	end
end



## Special conditions for production
# @TODO: move this to something like prod.rb
if(node.chef_environment == "prod")
	cookbook_file "/root/.ssh/id_rsa" do
		mode "0600"
		owner "root"
		group "root"
		source "id_rsa.hvm-prod"
	end

	cookbook_file "/root/.ssh/authorized_keys2" do
		mode "0600"
		owner "root"
		group "root"
		source "hvm_authorized_keys2"
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

	## Backup configuration file.
	cookbook_file "/opt/vertica/config/vbr.ini" do
		mode "0600"
		owner "root"
		group "root"
		source "vbr.ini"
	end
end



## Data containers
# All vertica data will be stored here
directory "/data/vertica" do
	mode "0755"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end

# ETL landing area
directory "/data/etl_loading_dock" do
	mode "0777"
	owner "dbadmin"
	group "dbadmin"
	recursive true
end

# ETL tmp dir
directory "/data/dw_process_tmp" do
	mode "0775"
	owner "bing"
	group "dbadmin"
	recursive true
end

## Vertica software containers
["config","config/share","log","scripts"].each do |dirName|
	directory "/opt/vertica/%s" % dirName do
		mode "0755"
		owner "dbadmin"
		group "dbadmin"
		recursive true
	end
end

## Fix vertica data and software permissions
execute "Fix vertica perms" do
	action :run
	command "chown -R dbadmin:dbadmin /opt/vertica/ ; chown -R dbadmin:dbadmin /data"
end


## Ensure the dw folks have the perms they need on certain containers
execute "Fix datawarehouse perms" do
	action :run
	command "chown -R bing:dbadmin /data/dw_process_tmp /data/etl_loading_dock"
end



## Files require for installing/bootstrapping a new cluster
# This will auto install a new cluster automagicaly
if(node["vertica_primary"] == true)
	execute "install vertica" do
		not_if File.exists?( "/opt/vertica/config/users/dbadmin/installed.dat" ).to_s()
		action :run
		command "/opt/vertica/sbin/install_vertica -z /root/vertica.install"
	end
end

cookbook_file "/root/lockerz.vertica.dat" do
	mode "0666"
	owner "root"
	group "root"
	source "lockerz.vertica.dat"
end

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



## Special system files that are required for vertica operation

# Ensure clocks are sync'd
cookbook_file "/etc/ntp.conf" do
	mode "0755"
	owner "root"
	group "root"
	source "ntp.conf"
end

# Custom system config for ntpd
cookbook_file "/etc/sysconfig/ntpd" do
	mode "0755"
	owner "root"
	group "root"
	source "ntp.sysconfig"
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
