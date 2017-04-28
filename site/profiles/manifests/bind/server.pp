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

}
