##
# MySQL client.
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com


package "mysql-5.0.77-4.el5_6.6.x86_64" do
  action :remove
end
package "MySQL-client"
package "MySQL-devel"
package "MySQL-shared"

