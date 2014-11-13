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
    windows_features=["NetFx4","NetFx3"]
    windows_features.each do |f|
      windows_feature f do
        action :install
        all true
      end
    end
    powershell_script "disable_firewall" do
      flags "-ExecutionPolicy Unrestricted"
      code <<-EOH
        netsh advfirewall set allprofiles state off
      EOH
    end
  end

include_recipe "jenkins::node"
