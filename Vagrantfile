require 'yaml'
#
# Single box with configuration defined in one Puppet module.
#
dir = File.dirname(File.expand_path(__FILE__))
configValues = YAML.load_file("#{dir}/drupal-site/config.yaml")
data = configValues['vagrantfile-local']

Vagrant.configure("2") do |config|

  config.vm.box = "#{data['vm']['box']}"
  config.vm.box_url = "#{data['vm']['box_url']}"
  config.vm.host_name = "#{data['vm']['hostname']}" + '.' + "#{data['vm']['domain']}"
  config.vm.synced_folder "drupal-site/docroot/", "/var/www/html/drupal"

  config.vm.provider "virtualbox" do |config|
    config.customize [
      'modifyvm', :id,
      '--name', "#{data['vm']['hostname']}",
      '--memory', "#{data['vm']['memory']}"
    ]
  end

  # Map network ports to local ports
  if data['vm']['network']['private_network'].to_s != ''
      config.vm.network "private_network", ip: "#{data['vm']['network']['private_network']}"
    end

    data['vm']['network']['forwarded_port'].each do |i, port|
      if port['guest'] != '' && port['host'] != ''
        config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i
      end
    end

    # Do Initial Setup
    config.vm.provision "shell" do |s|
        s.path = "shell/initial-setup.sh"
        s.args = "/vagrant"
        s.keep_color = true
      end

  # Lets make sure that we're running the latest puppet on the VM.
  #config.vm.provision :shell, :path => "shell/update-puppet.sh"

  config.vm.provision "puppet" do |puppet|
   puppet.options = "--hiera_config /vagrant/drupal-site/puppet/hiera.yaml"
#    puppet.options = "--verbose --debug --hiera_config /vagrant/drupal-site/puppet/hiera.yaml"
    puppet.manifests_path = 'drupal-site/puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = [ 'drupal-site/puppet/forge-modules', 'drupal-site/puppet/custom-modules' ]
  end
end
