# profiles::system::hostname
#
# This class manages hostname on a system
#
class profiles::system::hostname (
  String $hostname = 'undef',
) {

  # In case we want to use a different hostname than the derivate from cert.
  # But we should not do that.
  if $hostname == 'undef' {
    $new_hostname = $trusted['hostname']
  }
  else {
    $new_hostname = $hostname
  }

  case $facts['osfamily'] {
    'RedHat' : {

      case $facts['os']['release']['major'] {
        '7': {
          exec { 'set_hostname_rhel7':
            command => "/bin/hostnamectl set-hostname ${new_hostname}",
            unless  => "hostname | grep -wE \"${new_hostname}\"",
          }
        }
        default: { fail( "profiles::system::hostname not supported on this OS major release." ) }
      }
    }

    default: { fail( "profiles::system::hostname not supported on this OS." ) }
  }


}
