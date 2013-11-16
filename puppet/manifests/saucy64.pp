# Configure Exec
Exec {
  path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

include java, elasticsearch
include mongodb

include php
include php::dev
include php::cli
include php::pear
include php::fpm
include php::composer
include php::phpunit
include php::extension::curl
include php::extension::intl
include php::extension::ldap
include php::extension::mcrypt
include php::extension::mysql
include php::extension::xdebug

php::config { 'php-extension-xdebug-settings':
  inifile  => '/etc/php5/mods-available/xdebug.ini',
  settings => {
    set => {
      '.anon/xdebug.default_enable' => '1',
      '.anon/xdebug.idekey' => 'vagrant',
      '.anon/xdebug.remote_enable' => '1',
      '.anon/xdebug.remote_autostart' => '0',
      '.anon/xdebug.remote_port' => '9000',
      '.anon/xdebug.remote_handler' => 'dbgp',
      '.anon/xdebug.remote_log' => '/var/log/xdebug/xdebug.log',
      '.anon/xdebug.remote_connect_back' => '1',
    }
  }
}

php::extension { 'mongo':
  ensure   => $php::params::ensure,
  provider => pecl,
  package  => "pecl.php.net/mongo",
}

php::config { 'php-extension-mongo':
  inifile  => '/etc/php5/mods-available/mongo.ini',
  settings => {
    set => {
      '.anon/extension' => 'mongo.so',
    }
  }
}

exec { "php5enmod mongo":
  onlyif => ["test -e /etc/php5/mods-available/mongo.ini"]
}

php::extension { 'xhprof':
  ensure   => $php::params::ensure,
  package  => 'pecl.php.net/xhprof-beta',
  provider => pecl
}

php::config { 'php-extension-xhprof':
  inifile  => '/etc/php5/mods-available/xhprof.ini',
  settings => {
    set => {
      '.anon/extension' => 'xhprof.so',
    }
  }
}

exec { "php5enmod xhprof":
  onlyif => ["test -e /etc/php5/mods-available/xhprof.ini"]
}

php::extension { 'apcu':
  ensure   => $php::params::ensure,
  package  => 'pecl.php.net/apcu-beta',
  provider => pecl
}

php::config { 'php-extension-apcu':
  inifile  => '/etc/php5/mods-available/apcu.ini',
  settings => {
    set => {
      '.anon/extension' => 'apcu.so',
      '.anon/apc.enabled' => '1',
    }
  }
}

exec { "php5enmod apcu":
  onlyif => ["test -e /etc/php5/mods-available/apcu.ini"]
}

php::config { 'custom-php-ini':
  inifile  => '/etc/php5/mods-available/custom-php.ini',
  settings => {
    set => {
      '.anon/short_open_tag'       => 'Off',
      '.anon/asp_tags'             => 'Off',
      '.anon/expose_php'           => 'Off',
      '.anon/memory_limit'         => '256M',
      '.anon/display_errors'       => 'Off',
      '.anon/log_errors'           => 'On',
      '.anon/post_max_size'        => '128M',
      '.anon/upload_max_filesize'  => '128M',
      '.anon/max_execution_time'   => 600,
      '.anon/allow_url_include'    => 'Off',
      '.anon/error_log'            => 'syslog',
      '.anon/output_buffering'     => 4096,
      '.anon/output_handler'       => 'Off',
      '.anon/date.timezone'       => 'Europe/Moscow'
    }
  }
}

exec { "php5enmod custom-php":
  onlyif => ["test -e /etc/php5/mods-available/custom-php.ini"]
}

Class['php::dev'] -> Class['php::pear'] -> Php::Extension <| |> -> Php::Config <| |>


class { 'nginx':
  confd_purge => true,
  manage_repo => false,
}

nginx::resource::vhost { 'php.development.vm':
  ensure   => present,
  www_root => '/vagrant/www',
}

nginx::resource::location { 'php.development.vm:php':
  ensure         => present,
  vhost          => 'php.development.vm',
  www_root       => '/vagrant/www',
  location       => '~ \.php$',
  fastcgi        => 'unix:/var/run/php5-fpm.sock',
  fastcgi_script => '$document_root$fastcgi_script_name',
}