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
  end

include_recipe "jenkins::node"
