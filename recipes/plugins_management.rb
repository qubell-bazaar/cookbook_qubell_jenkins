#
# Jenkins plugin management recipe
#

jenkins_plugin node['jenkins']['server']['plugins'] do
  action :"#{node['jenkins']['server']['action']}"
end
