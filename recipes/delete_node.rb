#
# Remove node
#

jenkins_cli "login" do
  url node['jenkins']['server']['url']
  username node['jenkins']['cli']['username']
  password node['jenkins']['cli']['password']
end
jenkins_cli "delete-node #{node['jenkins']['node']['name']}" do
  url node['jenkins']['server']['url']
  #username node['jenkins']['cli']['username']
  #password node['jenkins']['cli']['password']
end
jenkins_cli "logout" do
  url node['jenkins']['server']['url']
  username node['jenkins']['cli']['username']
  password node['jenkins']['cli']['password']
end
