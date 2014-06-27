VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #Ubuntu 12.04
  config.vm.define "ubuntu12" do |ubuntu12_config|
    ubuntu12_config.vm.box = "ubuntu-12-x64"
    ubuntu12_config.vm.box_url = "https://s3.amazonaws.com/vagrant-bx/ubuntu-12-x64.box"
    ubuntu12_config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    ubuntu12_config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
    ubuntu12_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    ubuntu12_config.vm.provision "chef_solo" do |chef| 
      chef.log_level = "debug"
      chef.cookbooks_path = ["berks/cookbooks"]
      chef.add_recipe "cookbook_qubell_jenkins"
        chef.json = {
          "jenkins" => {
            "server" => {
              "install_method" => "war",
              "version" => "1.568",
              "admin_password" => "123qweasd",
              "host" => "10.0.2.15"
            } 
          }
        }
    end
  end
  #Centos 6.4
  config.vm.define "centos63" do |centos63_config|
    centos63_config.vm.box = "centos-6-x64"
    centos63_config.vm.box_url = "https://s3.amazonaws.com/vagrant-bx/centos-6-x64.box"
    centos63_config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    centos63_config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
    centos63_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    centos63_config.vm.provision "chef_solo" do |chef| 
      chef.log_level = "debug"
      chef.cookbooks_path = ["berks/cookbooks"]
      chef.add_recipe "cookbook_qubell_jenkins"
        chef.json = {
          "jenkins" => {
            "server" => {
              "install_method" => "war",
              "version" => "1.568",
              "admin_password" => "123qweasd",
              "host" => "10.0.2.15"
            } 
          }
        }
    end
  end
end
