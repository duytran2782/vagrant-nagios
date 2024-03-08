Vagrant.configure("2") do |config|
  IMAGE_NAME="generic/centos7"
  config.vm.box = IMAGE_NAME

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

    monitor.vm.provision "shell", path: "./provision-4.4.2.sh"
  end
# ----- ganglia nrbe ------
  servers=[
    {
      :hostname => "worker1",
      :box => IMAGE_NAME,
      :ip => "10.10.10.11"
    },
    {
      :hostname => "worker2",
      :box => IMAGE_NAME,
      :ip => "10.10.10.12"
    }
  ]

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
    
      node.vm.network :private_network, ip: machine[:ip]

      node.vm.provision "shell", path: "./provision-3.0.6.sh"
    end
  end
end