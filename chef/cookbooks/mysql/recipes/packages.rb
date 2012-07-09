
## Packages
package "php53-mysql" do
  action :remove
end
package "mysql" do
  action :remove
end

package "MySQL-client"
package "MySQL-server"
package "MySQL-devel"
package "MySQL-shared-compat"

