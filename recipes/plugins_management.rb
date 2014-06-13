#
# Jenkins plugin management recipe
#

node['jenkins']['server']['plugins'].each do |plugin|
  if plugin.is_a?(Hash)
    name = plugin['name']
    version = plugin['version'] if plugin['version']
    url = plugin['url'] if plugin['url']
  else
    name = plugin
  end

  jenkins_plugin name do
    action :"#{node['jenkins']['server']['plugins_action']}"
    version version if version
    url url if url
  end
end
