Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "vagrant-provision.sh", keep_color: true
  config.vm.provision :shell, path: "install-sources.sh", privileged: false, keep_color: true
  config.vm.provision :shell, path: "user-provision.sh", privileged: false, keep_color: true
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network "private_network", type: "dhcp"
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end

