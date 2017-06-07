# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # We're using Ubuntu 16.04 - this one doesn't have a problem with GRUB on apt-get update like others do
  config.vm.box = "geerlingguy/ubuntu1604"

  # Default SSH credentials
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  # Set up settings specific to the virtual machine
  config.vm.provider :virtualbox do |vb|

      # Give the poor thing some memory...
      vb.memory = 2048

      # Allow Vagrant to access host's internet data
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

      # Allow X11 forwarding (xclip needs it for headless servers)
      vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
  end

  # To use ssh from this box, needs to forwarded to host
  config.ssh.forward_agent=true

  # Get rid of annoying ttyl errors
  config.vm.provision :shell do |shell|
    shell.inline = "touch $1 && chmod 0440 $1 && echo $2 > $1"
    shell.inline = "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"
    shell.args = %q{/etc/sudoers.d/root_ssh_agent "Defaults    env_keep += \"SSH_AUTH_SOCK\""}
  end

  # Enable auto-updating of host's hosts file
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if hostname = (vm.ssh_info && vm.ssh_info[:host])
          `vagrant ssh -c "hostname -I"`.split()[1]
      end
  end

  config.vm.define "app" do|app|
    app.vm.hostname = "app.local"

    # Automatically be given an available IP address - hostmanager plugin updates /etc/hosts on host machine with the IP
    app.vm.network "private_network", type: "dhcp"

    app.vm.provision :shell, path: "vagrant/install.sh"
  end
end
