#
# Recipe restore Jenkins from backup
#

service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action :stop
end

require "pathname"

if ( node["jenkins"]["backup_uri"].start_with?('http:','https:','ftp:','file:'))
  require 'uri'
  backup = node['jenkins']['backup_uri']
  uri = URI.parse(backup)
  file_name = File.basename(uri.path)
  ext_name = File.extname(file_name)
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

  case node['jenkins']['server']['restore_backup']
  when "full"
    #run cleanup jenkins_home and extract all files from archive to jenkins_home
    case ext_name
    when ".gz"
      bash "restore full jenkins backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['server']['home']}
        mkdir #{node['jenkins']['server']['home']}
        tar -xzvf #{target_file} -C #{node['jenkins']['server']['home']}/
        chown -R #{node['jenkins']['server']['user']}:#{node['jenkins']['server']['group']}
        EOH
      end

    when ".zip"
      package "zip" do
        action :install
      end

      bash "restore full jenkins backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['server']['home']}
        mkdir #{node['jenkins']['server']['home']}
        unzip -o #{target_file} -d #{node['jenkins']['server']['home']}/
        chown -R #{node['jenkins']['server']['user']}:#{node['jenkins']['server']['group']} #{node['jenkins']['server']['home']}
        EOH
      end
    end

  when "jobs"
    #run cleanup on  jenkins_home/jobs and extract all files from archive
    case ext_name
    when ".gz"
      bash "restore jenkins jobs backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['server']['home']}/jobs
        mkdir #{node['jenkins']['server']['home']}/jobs
        tar -xzvf #{target_file} -C #{node['jenkins']['server']['home']}/jobs/
        chown -R #{node['jenkins']['server']['user']}:#{node['jenkins']['server']['group']} #{node['jenkins']['server']['home']}/jobs
        EOH
      end
    when ".zip"
      package "zip" do
        action :install
      end 

      bash "restore jenkins jobs backup" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['server']['home']}/jobs
        mkdir #{node['jenkins']['server']['home']}/jobs
        unzip -o #{target_file} -d #{node['jenkins']['server']['home']}/jobs/
        chown -R #{node['jenkins']['server']['user']}:#{node['jenkins']['server']['group']} #{node['jenkins']['server']['home']}/jobs
        EOH
      end
    end
  when "job"
    #run cleanup on jenkins_home/jobs/job_name and extract files fom archive
    case ext_name
    when ".gz"
      bash "restore jenkins job #{target_file} " do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['server']['home']}/jobs/#{file_name}
        tar -xzvf #{target_file} -C #{node['jenkins']['server']['home']}/jobs/#{file_name}
        chown -R #{node['jenkins']['server']['user']}:#{node['jenkins']['server']['group']} #{node['jenkins']['server']['home']}/jobs/#{file_name}
        EOH
        end
    when ".zip"
      package "zip" do
        action :install
      end
      bash "restore jenkins job #{target_file}" do
        user "root"
        code <<-EOH
        rm -rf #{node['jenkins']['server']['home']}/jobs/#{file_name}
        unzip -o #{target_file} -d #{node['jenkins']['server']['home']}/jobs/#{file_name}
        chown -R #{node['jenkins']['server']['user']}:#{node['jenkins']['server']['group']} #{node['jenkins']['server']['home']}/jobs/#{file_name}
        EOH
      end
    end
  end
  service "jenkins" do
    action :start
  end
end
