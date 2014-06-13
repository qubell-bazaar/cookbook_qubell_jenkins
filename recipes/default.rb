case node[:platform_family]
  when "debian"
    execute "update packages cache" do
      command "apt-get update"
    end
    
    service "ufw" do
      action :stop
    end
  when "redhat"
    execute "add gpg key" do
      command "sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
    end

    service "iptables" do
      action :stop
    end
  end

include_recipe "jenkins::server"

template ::File.join(node['jenkins']['server']['home'], "config.xml") do
  owner node['jenkins']['server']['user']
  group 'nogroup'
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
  group 'nogroup'
  action :create
  notifies :restart, 'service[jenkins]', :delayed
end

case node["platform_family"]
  when "debian"
  end
