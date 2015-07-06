#
# Jenkins plugin management recipe
#

node.run_state[:jenkins_username] = node[:jenkins][:cli][:username]
node.run_state[:jenkins_password] = node[:jenkins][:cli][:password]

node['jenkins']['master']['plugins'].each do |plugin|
  if plugin.is_a?(Hash)
    name = plugin['name']
    version = plugin['version'] if plugin['version']
    url = plugin['url'] if plugin['url']
    action = plugin['action'] if plugin['action']
  else
    name = plugin
    version = nil
    url = nil
    action = nil
  end

  jenkins_plugin name do
    action action
    version version
    source url
  end
end

service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action :restart
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
