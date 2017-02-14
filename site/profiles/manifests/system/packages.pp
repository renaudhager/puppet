# profiles::system::packages
#
# Required modules :
# - puppetlabs/apt
#
class profiles::system::packages (
  String $ensure = 'present',
) {
  # DeepMerge bug, we have to set this here
  $packages = hiera_hash( 'profiles::system::packages::packages', {} )

  case $::osfamily {
    'Debian': {

      $defaults = {
        ensure  => $ensure,
        require => Exec['apt_update'],
      }
    }
    default: {
      $defaults = {
        ensure => $ensure,
      }
    }
  }

  create_resources( package, $packages, $defaults )
}
