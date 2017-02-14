# profiles::puppet::server
#
# This class configure puppetserver
#
#
# TODO : Make Unt tests
class profiles::puppet::server (
  $gitlab_api_token    = undef,
  $gitlab_url          = undef,
  $gitlab_project      = undef,
  $config_java_args    = {},
  $config_puppetserver = {},
  $config_bootstrap    = {},
  $settings            = {},
) {
  validate_hash( $config_java_args )
  validate_hash( $config_bootstrap )
  validate_hash( $settings )

  package { ['make','gcc']:
    ensure => present,
  }

  file { '/etc/puppetlabs/code/hiera.yaml':
    source => 'puppet:///modules/profiles/puppet/server/hiera.yaml',
    owner  => 'root',
    group  => 'root',
    notify => Service['puppetserver'],
  }


  file { '/etc/puppetlabs/puppetserver/conf.d/webserver.conf':
    content => template( "${module_name}/puppet/server/webserver.erb" ),
    owner   => 'root',
    group   => 'root',
    notify  => Service['puppetserver'],
  }


  file { '/etc/puppetlabs/puppet/autosign.conf':
    source => 'puppet:///modules/profiles/puppet/server/autosign.conf',
    owner  => 'root',
    group  => 'root',
    notify => Service['puppetserver'],
  }

  # preserve_knockout functionnality / No valid releases
  file { '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/vendor/deep_merge/lib/deep_merge/core.rb':
    source => 'puppet:///modules/profiles/puppet/server/deep_merge_core.rb',
    owner  => 'root',
    group  => 'root',
    notify => Service['puppetserver'],
  }

  file { '/usr/local/bin/r10-deploy.bash':
    ensure => 'present',
    source => 'puppet:///modules/profiles/puppet/server/r10k-deploy.bash',
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
  }

  file { '/var/log/puppetlabs/r10k/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  cron { 'r10-deploy':
    ensure  => 'present',
    command => '/usr/local/bin/r10-deploy.bash',
    user    => 'root',
    hour    => ['*'],
    minute  => '*/2',
    require => File['/usr/local/bin/r10-deploy.bash'],
}

  if ! empty( $settings ) {
    create_resources( puppet::setting, $settings )
  }

  ## camptocamp/puppetserver config

  if ! empty( $config_java_args ) {
    create_resources( puppetserver::config::java_arg, $config_java_args )
  }

  if ! empty( $config_bootstrap ) {
    create_resources( puppetserver::config::bootstrap, $config_bootstrap )
  }


}
