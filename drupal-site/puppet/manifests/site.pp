include baseconfig
include apache
apache::vhost { 'devops.dev':
  ensure     => 'present',
  vhost_name => '*',
  port       => '80',
  ssl        => true,
  override   => 'all',
  docroot    => '/var/www/html/drupal',
}

include ::mysql::server

mysql::db { 'drupal':
  user     => 'drupal',
  password => 'drupal',
  host     => 'localhost',
  grant    => ['ALL'],
}

class {'::mysql::bindings':
  php_enable => true,
}

include php::mod_php5

php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}
php::module { [ 'pecl-apc', 'xml', 'gd' ]: }
php::module::ini { 'pecl-apc':
  settings => {
    'apc.enabled'      => '1',
    'apc.shm_segments' => '1',
    'apc.shm_size'     => '64M',
  }
}

class { 'drupal':
  installtype    => 'remote',
  database       => 'drupal',
  dbuser         => 'drupal',
  dbdriver       => 'mysql',
  admin_password => 'pass',
  require => Php::Module[ 'pecl-apc', 'xml', 'gd' ],
}

#$enable_modules = prefix([ 'admin_menu', 'views' ], 'devops.dev::')
#drupal_module { $enable_modules:
#  ensure => present,
#  require => Class['drupal'],
#}
#
#$disable_modules = prefix([ 'toolbar', 'overlay' ], 'devops.dev::')
#drupal_module { $disable_modules:
#  ensure => absent,
#  require => Class['drupal'],
#}
