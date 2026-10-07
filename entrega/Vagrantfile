# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :controlNode do |controlNode|
    controlNode.vm.box = "bento/ubuntu-22.04"
    controlNode.vm.hostname = "controlNode"
    controlNode.vm.network :private_network, ip: "192.168.100.10"
    controlNode.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 2048
    end

    # Arregla el DNS en cada vagrant up / vagrant reload
    controlNode.vm.provision "shell", run: "always", inline: <<-SHELL
      resolvectl dns eth0 8.8.8.8 8.8.4.4
    SHELL
  end

end