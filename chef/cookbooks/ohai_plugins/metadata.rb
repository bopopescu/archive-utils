maintainer       "Lockerz"
maintainer_email "nathaniel@lockerz.com"
license          "All rights reserved"
description      "Installs/Configures ohai_plugins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "ohai_plugins::dpkg", "Installs dpkg ohai plugin"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends 'ohai', '>= 1.1.0'
