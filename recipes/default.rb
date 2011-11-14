#
# Cookbook Name:: chef-client
# Recipe:: default
#

# chef clinet is installed during bootstrap

chef_version = node.chef_client.version
chef_node_name = Chef::Config[:node_name] == node["fqdn"] ? false : Chef::Config[:node_name]

package node.chef_client.pkg do
  version chef_version
end

# NOTE: Carefull here, on chef-server some of those have to owned by chef user
%w{run_path cache_path backup_path log_dir}.each do |k|
	directory node["chef_client"][k] do
  	recursive true
  	owner "root"
  	group "root"
  	mode 0755
	end
end

# For gem installations we have to drop startup init script.
if !node["platform"] == "ubuntu"
  init_content = IO.read("#{node["languages"]["ruby"]["gems_dir"]}/gems/chef-#{chef_version}/distro/#{dist_dir}/etc/init.d/chef-client")
  file "/etc/init.d/chef-client" do
    content init_content
    mode 0755
    notifies :restart, "service[chef-client]", :delayed
  end
end

conf_dir = value_for_platform(
	["ubuntu"] => { "default" => "default" },
	["amazon", "redhat", "centos"] => { "default" => "sysconfig"}
)

template "/etc/#{conf_dir}/chef-client" do
	source "chef-client-conf.erb"
	owner "root"
	group "root"
	mode 0644
	notifies :restart, "service[chef-client]", :delayed
end

service "chef-client" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template "/etc/chef/client.rb" do
  source "client.rb.erb"
  owner "root"
  group "root"
  mode 0644
  variables :chef_node_name => chef_node_name
  notifies :create, "ruby_block[reload_client_config]"
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("/etc/chef/client.rb")
  end 
  action :nothing
end
