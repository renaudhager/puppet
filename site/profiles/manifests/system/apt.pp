# profiles::apt
#
# Interface to manage apt resources from the official module
#
# Required modules:
# - puppetlabs/apt
#
class profiles::system::apt (
  $proxy_host      = undef,
  $proxy_port      = undef,
  $location        = undef,
  $ubuntu_location = undef,
  $debian_location = undef,
  $include_src     = undef,
  $key_server      = undef,
) {
  # DeepMerge bug, we have to set this here
  $sources = hiera_hash( 'profiles::system::apt::sources', {} )
  $keys    = hiera_hash( 'profiles::system::apt::keys', {} )

  if ! $location {
    case $::operatingsystem {
      'Debian': {
        $sources_defaults = {
          location    => $debian_location,
          include_src => $include_src,
        }
      }
      'Ubuntu': {
        $sources_defaults = {
          location    => $ubuntu_location,
          include_src => $include_src,
        }
      }
      default: {
        fail( 'os not supported by profile' )
      }
    }
  }
  else {
    $sources_defaults = {
      location    => $location,
      include_src => $include_src,
    }
  }

  if $proxy_host != undef {
    $key_options = "http-proxy=\"http://${proxy_host}:${proxy_port}/\""
  }
  else {
    $key_options = undef
  }

  $keys_defaults = {
    key_server  => $key_server,
    key_options => $key_options,
  }

  create_resources( apt::source, $sources, $sources_defaults )
  create_resources( apt::key, $keys, $keys_defaults )
}
