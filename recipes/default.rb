case node[:platform_family]
  when "debian"
    execute "update packages cache" do
      command "apt-get update"
    end
    
    service "ufw" do
      action :stop
    end
  when "rhel"
    service "iptables" do
      action :stop
    end
  end

include_recipe "jenkins::server"

template ::File.join(node['jenkins']['server']['home'], "config.xml") do
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['group']
  source "config.xml.erb"
  #action :create_if_missing
  notifies :restart, 'service[jenkins]', :delayed
end

# Create admin user
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['jenkins']['server']['admin_password'] = secure_password
require 'openssl'
salt = OpenSSL::Random::random_bytes(4).unpack('H*')[0]
pwencoded = OpenSSL::Digest::SHA256::hexdigest("#{node.jenkins.server.admin_password}{#{salt}}")
cookbook_qubell_jenkins_user "admin" do
  comment "Global Admin"
  password "#{salt}:#{pwencoded}"
  action :create
end

directory ::File.join(node['jenkins']['server']['home'], "plugins") do
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['group']
  action :create
  notifies :restart, 'service[jenkins]', :delayed
end

node.set['qubell_jenkins']['state']="installed"

if (!node['qubell_jenkins']['plugins'].empty?)
  node.set['jenkins']['server']['plugins']=node['qubell_jenkins']['plugins']
  include_recipe "cookbook_qubell_jenkins::plugins_management"
end

if (!node['qubell_jenkins']['backup_uri'].empty? && !node['qubell_jenkins']['restore_type'].empty?)
  include_recipe "cookbook_qubell_jenkins::restore_backup"
end
