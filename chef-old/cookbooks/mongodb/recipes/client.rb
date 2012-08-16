# Mongo recipe
#

package "mongo" do
	case node[:platform]
	when "centos","redhat"
	package_name "mongo"
	end
	action :install
end

