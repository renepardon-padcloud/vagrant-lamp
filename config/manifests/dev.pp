node default {
  Php::Extension <| |> -> Php::Config <| |> ~> Service["apache2"]
  #Apt::Source <| |> ~> Exec['apt_update'] -> Package <| |>

  Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',  ],
    logoutput => on_failure,
  }

  package { ['augeas-tools', 'libaugeas-dev', 'libaugeas-ruby']:   ensure => installed }

  $php_version = '5.4.*'

  include php
  include php::apt

  class {
    'php::cli':
    ensure => $php_version;
    'php::apache':
    ensure => $php_version;
    'php::dev':
    ensure => $php_version;
    'php::pear':
    ensure => $php_version;
    'php::extension::apc':
    ensure => $php_version;
    'php::composer': ;
  }

  class { 'mysql::server':
    config_hash => { 'root_password' => 'root' }
  }

  include mysql::php

  class {'apache': default_mods => false }

  apache::vhost { 'tinyshop.dev':
    priority        => '10',
    vhost_name      => 'tinyshop',
    port            => '80',
    docroot         => '/var/www/app/',
    serveradmin     => 'webmaster@example.com',
  }

  include lighttpd
}