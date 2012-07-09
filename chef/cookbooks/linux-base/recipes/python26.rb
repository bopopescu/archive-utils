# Setup python 2.6 with the libraries we commonly want to use

package "python26"

bash "install-setuptools" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   sh /usr/lib/python2.6/site-packages/setuptools-0.6c11-py2.6.egg
  EOH
  action :nothing
end

cookbook_file "/usr/lib/python2.6/site-packages/setuptools-0.6c11-py2.6.egg" do
  source "setuptools-0.6c11-py2.6.egg"
  owner "root"
  group "root"
  mode "0544"
  notifies :run, resources(:bash => "install-setuptools"), :immediately
end

bash "install-pip" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   easy_install pip
  EOH
  not_if "test -f /usr/bin/pip"
end

bash "install-boto" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   pip install boto
  EOH
  not_if "test -d /usr/lib/python2.6/site-packages/boto"
end

bash "install-pynag" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   pip install pynag
  EOH
  not_if "test -d /usr/lib/python2.6/site-packages/pynag"
end

bash "install-gdata" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   pip install gdata
  EOH
  not_if "test -d /usr/lib/python2.6/site-packages/gdata"
end

bash "install-mechanize" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   pip install mechanize
  EOH
  not_if "test -d /usr/lib/python2.6/site-packages/mechanize"
end

bash "install-BeautifulSoup" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   pip install BeautifulSoup
  EOH
  not_if "test -f /usr/lib/python2.6/site-packages/BeautifulSoup.py"
end

