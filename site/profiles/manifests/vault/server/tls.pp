# profiles::vault::server::tls
#
# This class manages cert/key file for vault servers nodes.
#

class profiles::vault::server::tls (
  String $encrypted_key_file = 'profiles/vault/server/tls/key.pem.enc',
  String $encrypted_key_file_path = '/etc/vault/ssl/key.pem.enc',
  String $tls_key_file_path = '/etc/vault/ssl/key.pem',
  String $cert_file = 'profiles/vault/server/tls/cert.pem',
  String $cert_file_path = '/etc/vault/ssl/cert.pem',
  String $encrytion_key_name = 'cert',
  String $vault_token_id = 'decrypt_cert',
  ) {

  file { '/etc/vault/ssl':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    require => Class['::vault'],
  }

  file { $cert_file_path:
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => file( $cert_file ),
    require => File['/etc/vault/ssl'],
  }

  file { $encrypted_key_file_path:
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => file( $encrypted_key_file ),
    require => File['/etc/vault/ssl'],
    notify  => Exec['decrypt_tls_key'],
  }

  file { $tls_key_file_path:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => File['/etc/vault/ssl'],
    notify  => Exec['decrypt_tls_key'],
  }

  exec { 'decrypt_tls_key':
    command     => "/usr/local/bin/vault-decrypt.bash -f ${encrypted_key_file_path} -k ${encrytion_key_name} -o ${tls_key_file_path} -ti ${vault_token_id}",
    refreshonly => true,
    require     => File[$encrypted_key_file_path],
  }

}
