# profiles::system::ca_cert
#
# This class vaul CA Cert on all nodes.

# TODO : use a hash to be able to install several ca cert.

class profiles::system::ca_cert (
  String $ca_cert_file = 'profiles/system/ca_cert/vault_ca_cert.pem',
  String $ca_cert_file_path = '/usr/share/ca-certificates/vault_ca_cert.crt',
  ) {

  file{ $ca_cert_file_path:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file( $ca_cert_file ),
    notify  => Exec['update-ca'],
  }

  exec { 'update-ca-conf':
    command => "echo \"\$(basename ${ca_cert_file_path})\" >> /etc/ca-certificates.conf",
    unless  => "grep \"\$(basename ${ca_cert_file_path})\" /etc/ca-certificates.conf",
    notify  => Exec['update-ca'],
  }

  exec { 'update-ca':
    command     => 'find /etc/ssl/certs -type l -maxdepth 1 -delete && /usr/sbin/update-ca-certificates',
    refreshonly => true,
  }

}
