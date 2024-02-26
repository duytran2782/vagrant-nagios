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
  # sudo firewall-cmd --reload
  # After that reload httpd and nagios service
  # you can check log apache with --- sudo tail -f /var/log/httpd/error_log
  config.vm.define :node do |node|
    node.vm.hostname = "node01"
    node.vm.network :private_network, ip: "10.10.10.10"

    node.vm.provision "shell", path: "./provision.sh"
  end
end