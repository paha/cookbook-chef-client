#
# Author: Pavel
# Cookbook Name: chef-client
#
default["chef_client"]["interval"] = "1800"
default["chef_client"]["splay"]    = "20"
default["chef_client"]["log_dir"]  = "/var/log/chef"
default["chef_client"]["server_url"] = "https://chef.#{domain}"
default["chef_client"]["validation_client_name"] = "chef-validator"
default["chef_client"]["init_style"]  = "init"
default["chef_client"]["run_path"]    = "/var/run/chef"
default["chef_client"]["cache_path"]  = "/var/cache/chef"
default["chef_client"]["backup_path"] = "/var/lib/chef"

case platform
when "redhat","centos","amazon"
  set.chef_client.version = "0.10.4-1.el5"
  set.chef_client.pkg = "rubygem-chef"
when "ubuntu"
  set.chef_client.pkg = "chef"
  set.chef_client.version = "0.10.4-1"
end
