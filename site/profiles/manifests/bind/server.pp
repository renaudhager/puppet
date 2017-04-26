# profiles::bind::server
#
# This class manages bind::server::conf resources.
#
# Required modules :
# - thias/bind
#

class profiles::bind::server (
)  {

  $confs = hiera_hash( 'profiles::bind::server::confs', {} )
  $controls = hiera_hash( 'profiles::bind::server::controls', {} )

  create_resources( bind::server::conf, $confs )

  if ! empty($controls) {
    file{ '/etc/named/controls':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/bind/controls.erb"),
      notify  => Service['named'],
    }
  }
  else {
    file{ '/etc/named/controls':
      ensure  => 'absent',
      notify  => Service['named'],
    }
  }

}
