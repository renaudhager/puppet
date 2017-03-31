# profiles::gluster::peers
#
# This class manages gluster::peers::conf resources.
#
# Required modules :
# - puppet/gluster
#

class profiles::gluster::peers (
)  {

  $peers = hiera_hash( 'profiles::gluster::peers::peers', {} )

  create_resources( gluster::peer, $peers )

}
