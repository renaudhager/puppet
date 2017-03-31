# profiles::gluster::mounts
#
# This class manages gluster::mounts resources.
#
# Required modules :
# - puppet/gluster
#

class profiles::gluster::mounts (
)  {

  $mounts = hiera_hash( 'profiles::gluster::mounts::mounts', {} )

  create_resources( gluster::mount, $mounts)

}
