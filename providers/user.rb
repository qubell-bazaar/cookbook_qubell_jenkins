#
# Cookbook Name:: jenkins
# Provider:: user
#

action :remove do
  username = new_resource.username || new_resource.id
  directory ::File.join(node['jenkins']['server']['home'], "users", username) do
    recursive true
    action :delete
  end
  new_resource.updated_by_last_action(true)
end

action :create do
  directory ::File.join(node['jenkins']['server']['home'], "users") do
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['group'] 
    action :create
  end

  username = new_resource.username || new_resource.id
  directory ::File.join(node['jenkins']['server']['home'], "users", username) do
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['group']
    action :create
  end
  template ::File.join(node['jenkins']['server']['home'], "users", username, "config.xml") do
    source "user.xml.erb"
    owner node['jenkins']['server']['user']
    group node['jenkins']['server']['group']
    variables(
      :fullname => new_resource.comment,
      :password => new_resource.password,
      :email => new_resource.email
    )
    action :create
  end
  new_resource.updated_by_last_action(true)
end

