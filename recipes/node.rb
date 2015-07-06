include_recipe "java"

case node[:platform_family]
  when "debian"
    execute "update packages cache" do
      command "apt-get update"
    end

    service "ufw" do
      action :stop
    end
  when "redhat"
    execute "add gpg key" do
      command "sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
    end

    service "iptables" do
      action :stop
    end
  when "windows"
#    windows_features=["NetFx4","NetFx3"]
#    windows_features.each do |f|
#      windows_feature f do
#        action :install
        #all true
#      end
#    end
    powershell_script "disable_firewall" do
      flags "-ExecutionPolicy Unrestricted"
      code <<-EOH
        netsh advfirewall set allprofiles state off
      EOH
    end
  end

node.run_state[:jenkins_username] = node[:jenkins][:cli][:username]
node.run_state[:jenkins_password] = node[:jenkins][:cli][:password]
case node[:platform]
  when "linux", "amazon"
  jenkins_jnlp_slave node[:jenkins][:node][:name] do
    availability node[:jenkins][:node][:availability]
    action :"#{node[:jenkins][:node][:action]}"
  end
  when "windows"
  jenkins_windows_slave node[:jenkins][:node][:name] do
    user '.\Administrator'
    password node[:jenkins][:windows][:password]
    availability node[:jenkins][:node][:availability]
    action :"#{node[:jenkins][:node][:action]}"
  end
end
