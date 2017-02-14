# profiles::consul_template::install
#
# This class install consul template agent.
#

class profiles::consul_template::install (
  Hash $instances = {},
  String $download_url = 'https://releases.hashicorp.com/consul-template/',
  String $version = '0.16.0',
  String $release = 'linux_amd64',
  ) {

    # Download binary
    exec { 'download_consul_template':
      command => "curl -o /tmp/consul-template_${version}_${$release}.zip https://releases.hashicorp.com/consul-template/${version}/consul-template_${version}_${$release}.zip",
      unless  => 'ls /usr/local/bin/consul-template',
      notify  => Exec['install_consul_template'],
    }

    # Install binary
    exec { 'install_consul_template':
      command => "unzip -d /usr/local/bin/ /tmp/consul-template_${version}_${$release}.zip",
      unless  => "ls /usr/local/bin/consul-template && /usr/local/bin/consul-template  -v 2>&1 | grep ${version}",
      require => Exec['download_consul_template'],
    }

    file { '/etc/consul-template':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

}
