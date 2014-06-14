#
# Jenkins plugin management recipe
#

service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

ruby_block 'block_until_operational' do
  block do
    Chef::Log.info "Waiting until Jenkins is listening on port #{node['jenkins']['server']['port']}"
    until JenkinsHelper.service_listening?(node['jenkins']['server']['port'])
      sleep 1
      Chef::Log.debug('.')
    end

    Chef::Log.info 'Waiting until the Jenkins API is responding'
    test_url = URI.parse("#{node['jenkins']['server']['url']}/api/json")
    until JenkinsHelper.endpoint_responding?(test_url)
      sleep 1
      Chef::Log.debug('.')
    end
  end
  action :nothing
end

#node['jenkins']['server']['plugins'].each do |plugin|
#  if plugin.is_a?(Hash)
#    name = plugin['name']
#    version = plugin['version'] if plugin['version']
#    url = plugin['url'] if plugin['url']
#  else
#    name = plugin
#  end
#
#  jenkins_plugin name do
#    action :"#{node['jenkins']['server']['plugins_action']}"
#    version "#{version}" if version
#    url "#{url}" if url
#  end
#end

node['jenkins']['server']['plugins'].each do |plugin|
  remote_file ::File.join(node['jenkins']['server']['home'], "plugins", "#{plugin}.hpi") do
    source "http://updates.jenkins-ci.org/latest/#{plugin}.hpi"
    owner node['jenkins']['server']['user']
    group  node['jenkins']['server']['group']
    notifies :restart, "service[jenkins]", :delayed
    notifies :create, "ruby_block[block_until_operational]", :delayed
  end
end
