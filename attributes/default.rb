default['qubell_jenkins']['version']=''
default['qubell_jenkins']['plugins']=[]
default['qubell_jenkins']['backup_uri']=''
default['qubell_jenkins']['restore_type']=''

if (!node['qubell_jenkins']['version'].empty?)
  set['jenkins']['server']['version']=node['qubell_jenkins']['version']
end

