# -*- mode: ruby -*-
# vi: set ft=ruby :
def Kernel.is_windows?
  # Detect if we are running on Windows
  processor, platform, *rest = RUBY_PLATFORM.split("-")
  platform == 'mingw32'
end
use_nfs = !Kernel.is_windows?

Vagrant::Config.run do |config|
  config.vm.box = "debian-606-x64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-606-x64.box"

  config.vm.customize ["modifyvm", :id, "--memory", 1024]
  config.vm.customize ["modifyvm", :id, "--cpus", 2]
  config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"] #see: https://github.com/mitchellh/vagrant/issues/391#issuecomment-5834770
  config.vm.customize ["modifyvm", :id, "--cpuhotplug", "on"]
  config.vm.customize ["modifyvm", :id, "--ioapic", "on"]

  config.ssh.forward_agent = true
  config.ssh.max_tries = 10

  config.vm.define :dev do | dev |
    #use better describing name
    dev.vm.host_name = "tinyshop.dev"
    dev.vm.network :hostonly, "192.168.0.123", :adpater => 2
    dev.vm.forward_port 80, 8080
    dev.vm.forward_port 3306, 13306

    # activate nfs on non windows hosts
    dev.vm.share_folder("v-root", "/var/www/app", ".", :nfs => use_nfs)

    # puppet provision for etshop development vm's
    dev.vm.provision :puppet do |puppet|
      puppet.manifests_path = "config/manifests"
      puppet.manifest_file = "dev.pp"
      puppet.module_path = "config/modules"
      puppet.options = "--summarize --debug"
    end
  end
end
