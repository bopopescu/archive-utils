node.default[:debian][:arch] = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "i686"
