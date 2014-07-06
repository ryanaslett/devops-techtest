# == Class: baseconfig
#
# Performs initial configuration tasks for the Vagrant box.
#
class baseconfig {
  file {
    '/home/vagrant/.bashrc':
      owner => 'vagrant',
      group => 'vagrant',
      mode  => '0644',
      source => 'puppet:///modules/baseconfig/bashrc',
  }
}
