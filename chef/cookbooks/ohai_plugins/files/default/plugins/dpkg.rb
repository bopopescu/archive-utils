provides "linux/dpkg"

require_plugin "platform_family"

dpkg Mash.new

if platform_family.eql?("debian")
  dpkg_output = %x[dpkg-query -W -f='dpkg["${Package}"] = { "version" => "${Version}", "status" => "${Status}" }\n']
  eval(dpkg_output)
end
