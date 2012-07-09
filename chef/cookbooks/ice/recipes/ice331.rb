# ICE 3.3.1 recipe
# 

package "ice" do
	package_name "ice"
	version "3.3.1-1.el6"
	action :install
end

package "ice-libs" do
	package_name "ice-libs"
	version "3.3.1-1.el6"
	action :install
end

package "ice-utils" do
	package_name "ice-utils"
	version "3.3.1-1.el6"
	action :install
end

package "ice-servers" do
	package_name "ice-servers"
	version "3.3.1-1.el6"
	action :install
end

