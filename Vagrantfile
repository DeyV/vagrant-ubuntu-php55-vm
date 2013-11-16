# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "saucy64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "path-to-packer-ubuntu-13.10-vagrant-box"

  # VM host name
  config.vm.hostname = "php.development.vm"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.99.199"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  nfs = (RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/)
  # config.vm.synced_folder ".", "/vagrant", :nfs => nfs
  config.vm.synced_folder ".", "/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider :virtualbox do |vb|
    # Boot with headless mode
    vb.gui = false
  
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    # Say to virtualbox the guest is an ubuntu 64 bits
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
  end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file saucy64.pp in the manifests_path directory.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "saucy64.pp"
    puppet.module_path = "puppet/modules"
    puppet.options = "--verbose --debug --hiera_config /vagrant/puppet/hiera.yaml"
  end

  # GuestAdditions custom installer
  config.vbguest.installer = CloudUbuntuVagrant
  config.vbguest.auto_reboot = true

end

class CloudUbuntuVagrant < VagrantVbguest::Installers::Ubuntu
  def install(opts=nil, &block)
    vm.communicate.sudo("apt-get -y -q purge virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11", opts, &block)
    @vb_uninstalled = true
    super
  end

  def running?(opts=nil, &block)
    return false if @vb_uninstalled
    super
  end
end
