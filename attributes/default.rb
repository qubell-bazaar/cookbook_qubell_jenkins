default['qubell_jenkins']['backup_uri'] = ''
default['qubell_jenkins']['restore_type'] = ''
default['qubell_jenkins']['state'] = '' 
default['jenkins']['master']['plugins'].tap do |plugin|
  plugin['name'] = nil
  plugin['version'] = nil
  plugin['url'] = nil
  plugin['action'] = nil
end
