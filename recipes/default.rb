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

if node['jenkins']['master']['version'].empty?
  node.set['jenkins']['master']['version'] = nil
end

include_recipe "java"
include_recipe "jenkins::master"

remote_file "/tmp/dummy.manager" do
  source "http://#{node["ipaddress"]}:#{node["jenkins"]["master"]["port"]}"
  backup false
  retries 30
  retry_delay 10
end

template ::File.join(node['jenkins']['master']['home'], "config.xml") do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  source "config.xml.erb"
  #action :create_if_missing
  notifies :restart, 'service[jenkins]', :delayed
end

# Create admin user
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['jenkins']['master']['admin_password'] = secure_password
jenkins_user "admin" do
  full_name "Global Admin"
  password node.jenkins.master.admin_password
  action :create
  notifies :restart, 'service[jenkins]', :delayed
end

bash "Waiting application start" do
  user "root"
  code <<-EOH
  i=0
  http=000
  while [ $i -le 30 ]; do
    if [ "$http" -ne "200" ] && [ "$http" -ne "403" ]; then
      sleep 10
      ((i++))
      http=`curl -s -w "%{http_code}" "http://#{node["ipaddress"]}:#{node["jenkins"]["master"]["port"]}" -o /dev/null`
    else
      exit 0
    fi
  done
  exit 1
  EOH
end

node.set['qubell_jenkins']['state']="installed"
