# profiles::bind::server
#
# This class manages bind::server::conf resources.
#
# Required modules :
# - puppetlabs/postgresql
#

class profiles::bind::server (
)  {

  $confs = hiera_hash( 'profiles::bind::server::confs', {} )

  create_resources( bind::server::conf, $confs )

}
