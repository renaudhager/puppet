# profiles::system::sudo
#
# Required modules:
# - saz/sudo
#
class profiles::system::sudo (

)  {
  # Deep Merge bug
  $rules = hiera_hash( 'profiles::system::sudo::rules', {} )

  $defaults = {
      priority => 10,
      content  => undef,
  }

  create_resources( sudo::conf, $rules, $defaults )
}
