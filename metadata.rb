maintainer       "Pavel Snagovsky"
maintainer_email "paha01@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures chef-client"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ ubuntu redhat centos amazon}.each {|os| supports os}
