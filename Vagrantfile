#
# Single box with configuration defined in one Puppet module.
#
box      = 'centos6'
url      = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box'
hostname = 'devopstest'
domain   = 'drupal.org'
ram      = '256'

Vagrant.configure("2") do |config|

  config.vm.box = box
  config.vm.box_url = url
  config.vm.host_name = hostname + '.' + domain

  config.vm.provider "virtualbox" do |config|
    config.vm.customize [
      'modifyvm', :id,
      '--name', hostname,
      '--memory', ram
    ]
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
  end
end
