# profiles::httpauth
#
class profiles::httpauth (

) {
  # DeepMerge bug, we have to set this here
  $users = hiera_hash( 'profiles::httpauth::users', {} )

  validate_hash( $users )

  create_resources( profiles::httpauth::users, $users )
}
