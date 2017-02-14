# profiles::vault::utils
#
# This class manages vault object on nodes.
# For instance renew token, deploy script to encrypt/decrypt object.
#

class profiles::vault::utils (
  Hash $tokens = {},
  String $tokens_file = '/etc/vault/tokens',
  String $vault_url = 'https://vault.service.vgt.consul:8200',
  ) {

  # Install file to encrypt/decrypt
  file {'/usr/local/bin/vault-decrypt.bash':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    #content => file ( 'profiles/vault/utils/vault-decrypt.bash' )
    content => template( "${module_name}/vault/utils/vault-decrypt.erb" ),
  }


  # Create necessary vault stuff on host where vault server is not running
  if $::role != 'mesos-master' {
    group { 'vault':
      ensure => 'present',
    }

    file { '/etc/vault/':
      ensure => 'directory',
      owner  => 'root',
      group  => 'vault',
      mode   => '0750',
    }

  }


  # Create file to store vault tokens
  file { $tokens_file:
    ensure  => 'present',
    owner   => 'root',
    group   => 'vault',
    mode    => '0640',
    require => [ File['/etc/vault/'], Group['vault'] ]
  }

  $tokens_defaults = {
    ensure => 'present',
    path   => $tokens_file,
  }

  # Store tokens in tokens file.
  create_resources( file_line, $tokens, $tokens_defaults )

  $hour = fqdn_rand(24)
  $minute = fqdn_rand(59)

  # Setup cronjob to renew tokens
  cron { 'renew-tokens':
    ensure  => 'present',
    command => "for token in `cat ${tokens_file} | cut -d \":\" -f 2`;do curl -s -X PUT -H \"X-Vault-Token: \$token\" ${vault_url}/v1/auth/token/renew-self  1>/dev/null 2>&1;done;",
    user    => 'root',
    hour    => $hour,
    minute  => $minute,
  }

}
