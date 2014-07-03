require 'yaml'
#
# Single box with configuration defined in one Puppet module.
#
dir = File.dirname(File.expand_path(__FILE__))
configValues = YAML.load_file("#{dir}/drupal-tuner/config.yaml")
data = configValues['vagrantfile-local']

Vagrant.configure("2") do |config|

  config.vm.box = "#{data['vm']['box']}"
  config.vm.box_url = "#{data['vm']['box_url']}"
  config.vm.host_name = "#{data['vm']['hostname']}" + '.' + "#{data['vm']['domain']}"

  config.vm.provider "virtualbox" do |config|
    config.customize [
      'modifyvm', :id,
      '--name', "#{data['vm']['hostname']}",
      '--memory', "#{data['vm']['memory']}"
    ]
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
  end
end
