# profiles::ppas
#
# Interface to manage ppa resources from the official module
#
# Required modules:
# - puppetlabs/apt
#
class profiles::system::ppas (
  Hash $ppas = {},
) {

  # DeepMerge bug, we have to set this here
  $ppas_source = hiera_hash( 'profiles::system::ppas::ppas', {} )

  create_resources( apt::ppa, $ppas_source)

}
