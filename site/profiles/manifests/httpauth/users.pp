# profiles::httpauth::users
#

# TODO : Add stuff to delete undefine users.
define profiles::httpauth::users (
  String $file,
  String $password,
  String $ensure      = 'present',
  String $unix_user   = 'root',
  String $permissions = '0644',
  String $command     = '/usr/bin/htpasswd -b',
) {

  # TODO, enhanced variable verification
  if ! empty( $file ) and ! empty( $password ) {
    file { $file:
      ensure => $ensure,
      owner  => $unix_user,
      mode   => $permissions,
    } ->

    exec { 'create_user':
      command => "${command} ${file} ${name} ${password}",
      unless  => "${command} -v ${file} ${name} ${password}",
    }
  }
  else {
    fail( 'Variables profiles::httpauth::users::file and profiles::httpauth::users::password must be set' )
  }
}
