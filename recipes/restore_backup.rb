#
# Recipe restore Jenkins from backup
#

service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action :stop
end

require "pathname"

if ( node["qubell_jenkins"]["backup_uri"].start_with?('http:','https:','ftp:','file:'))
  require 'uri'
  backup = node['qubell_jenkins']['backup_uri']
  uri = URI.parse(backup)
  file_name = File.basename(uri.path)
  ext_name = File.extname(file_name)
  name = file_name[/([^\.]+)/]
  target_file = "/tmp/#{file_name}"
  
  #check is extention zip|tar.gz
  if ( ! %w{.zip .gz }.include?(ext_name))
    fail "not supported"
  end
  
  #download to target_file
  if ( backup.start_with?('http','ftp'))
    remote_file "#{target_file}" do
      source backup
    end
  elsif ( backup.start_with?('file'))
    target_file = URI.parse(backup).path
  end
  
  file_name = File.basename(target_file)

  case node['qubell_jenkins']['restore_type']
  when "full"
    #run cleanup jenkins_home and extract all files from archive to jenkins_home
    case ext_name
    when ".gz"
      bash "restore full jenkins backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['master']['home']}
        mkdir #{node['jenkins']['master']['home']}
        tar -xzvf #{target_file} -C #{node['jenkins']['master']['home']}/
        chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}
        EOH
      end

    when ".zip"
      package "zip" do
        action :install
      end

      bash "restore full jenkins backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['master']['home']}
        mkdir #{node['jenkins']['master']['home']}
        unzip -o #{target_file} -d #{node['jenkins']['master']['home']}/
        chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}
        EOH
      end
    end
  
    #change pass
    ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
    node.set_unless['jenkins']['master']['admin_password'] = secure_password
    jenkins_user "admin" do
      full_name "Global Admin"
      password node.jenkins.master.admin_password
      action :create
      notifies :start, 'service[jenkins]', :delayed
    end
   
  when "jobs"
    #run cleanup on  jenkins_home/jobs and extract all files from archive
    case ext_name
    when ".gz"
      bash "restore jenkins jobs backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['master']['home']}/jobs
        mkdir #{node['jenkins']['master']['home']}/jobs
        tar -xzvf #{target_file} -C #{node['jenkins']['master']['home']}/jobs/
        chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}/jobs
        EOH
      end
    when ".zip"
      package "zip" do
        action :install
      end 

      bash "restore jenkins jobs backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['master']['home']}/jobs
        mkdir #{node['jenkins']['master']['home']}/jobs
        unzip -o #{target_file} -d #{node['jenkins']['master']['home']}/jobs/
        chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}/jobs
        EOH
      end
    end
  when "job"
    #run cleanup on jenkins_home/jobs/job_name and extract files fom archive
    case ext_name
    when ".gz"
      bash "restore jenkins job #{name} " do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['master']['home']}/jobs/#{name}
        mkdir #{node['jenkins']['master']['home']}/jobs/#{name}
        tar -xzvf #{target_file} -C #{node['jenkins']['master']['home']}/jobs/#{name}
        chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}/jobs/#{name}
        EOH
        end
    when ".zip"
      package "zip" do
        action :install
      end
      bash "restore jenkins job #{name}" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['master']['home']}/jobs/#{name}
        mkdir #{node['jenkins']['master']['home']}/jobs/#{name}
        unzip -o #{target_file} -d #{node['jenkins']['master']['home']}/jobs/#{name}
        chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}/jobs/#{name}
        EOH
      end
    end
  end
end

service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action :start
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

require 'digest/md5'
node.set['qubell_jenkins']['state'] = Digest::MD5.hexdigest(Time.now.to_s)
