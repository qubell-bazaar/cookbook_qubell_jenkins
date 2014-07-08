Vagrant.configure("2") do |config|

  ###WINDOWS 2012
  config.vm.define "win" do |win_config|
    win_config.vm.communicator = "winrm"
    win_config.vm.synced_folder '.', '/vagrant', :disabled => true
    #win_config.vm.box = "dummy"
    win_config.vm.box = "windows-7-enterprise-i386.box"
    #win_config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    win_config.vm.box_url = "http://vagrantboxes.devopslive.org/windows-7-enterprise-i386.box"
  
    #PROVIDER
    win_config.vm.provider :aws do |aws, override|
      aws.access_key_id = "AKIAJKVQADRMSU2HZ4CQ"
      aws.secret_access_key = "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"
      aws.keypair_name = "dev"
      aws.ami = "ami-1adc1b72"
      aws.region = "us-east-1"
      aws.instance_type = "m1.medium"
      aws.security_groups = ["default"]
      aws.tags = {
        'Name' => 'Win jenkins slave'
      }
    end
  
    #PROVISIONING
    #win_config.vm.provision "chef_solo" do |chef|  
    #  chef.log_level = "debug"
    #  chef.cookbooks_path = ["berks/cookbooks"]
    #  chef.add_recipe "cookbook_qubell_jenkins::node"
    #  chef.json = {
    #    "jenkins" => {
    #      "server" => {
    #        "url" => "http://54.89.6.3:8080",
    #        "pubkey" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClG1xFLxSLx0U0tncWjFpuZ8f5u49xdgQV5ivAJAEGB36y8O+7y4TLbjBege6vy+S432GVDEePlJAgmJahLswIXbFpU1kzNMVrV7b0a7aJ7NW3vwuQ3f8/ve2o40mjCmNzR35KRnl8FDxOGOE+aenfQkF5PqBPEA10Iua5pwTKCXmmlqabIp9FFQnoUQ0jyUKpu7ctfa7dxHwaYWj5zOJppwjwOzsd7OFok6UtJDBaArXrZFbsnjB+N7Isi/t6y48cRcwRUQS41ND2Zzh6bHmUMihwY6vrBoX3xTkvmQefMNiLrRIWWNCCUgCZ3o9dRrvAsOJysV07VIizeSavIqrd jenkins@ip-10-238-254-15"
    #      },
    #      "node" => {
    #        "agent_type" => "windows",
    #        "availability" => "always"
    #      },
    #      "cli" => {
    #        "username" => "admin",
    #        "password" => "_xRWWrpgv6lPQUP_miTz"
    #      }
    #    },
    #    "java" => {
    #      "windows" => {
    #        "url" => "https://s3.amazonaws.com/ab-comp/jdk-7u60-windows-x64.exe"
    #      }
    #    }
    #  }
    #end
  end
end
