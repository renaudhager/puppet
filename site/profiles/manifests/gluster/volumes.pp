# profiles::gluster::volumes
#
# This class manages gluster::volumes::conf resources.
#
# Required modules :
# - puppet/gluster
#

class profiles::gluster::volumes (
)  {

  $volumes = hiera_hash( 'profiles::gluster::volumes::volumes', {} )

  create_resources( gluster::volume, $volumes)

}
