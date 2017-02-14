# profiles::marathon::install
#
# Install java prerequisite for marathon
# before installing marathon
#
# Required modules:
# - meltwater/marathon
#
class profiles::marathon::install (
  Array $masters = [],
  Array $zk      = [],
) {

  # Fix waiting I setup a personal repo
  exec { 'install_java8':
    command => 'curl -s -k -O https://cloud.renorains.net/extra/java8-runtime-headless_8u101_amd64.deb && dpkg -i java8-runtime-headless_8u101_amd64.deb',
    unless  => 'dpkg -l | grep java8-runtime-headless'
  }

  exec { 'configure_java':
    command => 'update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_101/bin/java 1 && update-alternatives --set java /usr/lib/jvm/jdk1.8.0_101/bin/java',
    unless  => 'java -version  2>&1| grep 1.8.0_101',
    require => Exec['install_java8'],
  }

  file { '/etc/marathon/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/marathon/conf/':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/marathon/'],
  }

  file { '/etc/marathon/conf/hostname':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $::hostname,
    require => File['/etc/marathon/conf/'],

  }

  # TODO : Need to put theses var in hiera
  if ( ! empty($masters) ) and ( ! empty($zk) ) {
    class { '::marathon':
      package_ensure => 'present',
      manage_repo    => false,
      install_java   => false,
      extra_options  => '--task_launch_timeout 600000',
      master         => $masters,
      zk             => $zk,
      require        => [ Exec['configure_java'], File['/etc/marathon/conf/hostname'] ],
    }
  }
  else {
    fail('master list and/or zk url cannot be empty.')
  }
}
