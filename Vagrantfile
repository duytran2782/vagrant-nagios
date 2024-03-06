Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos7"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Need to check firewall on VM
  # sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
  # sudo firewall-cmd --zone=public --list-services
  # sudo firewall-cmd --reload
  # After that reload httpd and nagios service
  # you can check log apache with --- sudo tail -f /var/log/httpd/error_log
  config.vm.define :monitor do |monitor|
    monitor.vm.hostname = "monitor"
    monitor.vm.network :private_network, ip: "10.10.10.10"

    monitor.vm.provision "shell", path: "./provision.sh"
  end

  config.vm.define :worker1 do |worker1|
    worker1.vm.hostname = "worker1"
    worker1.vm.network :private_network, ip: "10.10.10.11"

    worker1.vm.provision "shell", path: "./provision.sh"
  end

  config.vm.define :worker2 do |worker2|
    worker2.vm.hostname = "worker2"
    worker2.vm.network :private_network, ip: "10.10.10.12"

    worker2.vm.provision "shell", path: "./provision.sh"
  end
end