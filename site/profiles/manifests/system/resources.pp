# profiles::resources
#
# This class manages common system resources
# It will be splitted into multiple classes soon in order to improve lisibility
#
class profiles::system::resources (
  $user_gid            = 100,
  $user_purge_ssh_keys = true,
  $user_manage_home    = true,
) {
  # DeepMerge bug, we have to set this here
  $users         = hiera_hash( 'profiles::system::resources::users', {} )
  $deleted_users = hiera_hash( 'profiles::system::resources::deleted_users', {} )
  $groups        = hiera_hash( 'profiles::system::resources::groups', {} )
  $files         = hiera_hash( 'profiles::system::resources::files', {} )
  $crons         = hiera_hash( 'profiles::system::resources::crons', {} )
  $sshkeys       = hiera_hash( 'profiles::system::resources::sshkeys', {} )
  $yumrepos      = hiera_hash( 'profiles::system::resources::yumrepos', {} )

  validate_hash( $users )
  validate_hash( $deleted_users )
  validate_hash( $groups )
  validate_hash( $files )
  validate_hash( $crons )
  validate_hash( $sshkeys )

  $defaults = {
    ensure => present,
  }

  $user_defaults = {
    ensure         => present,
    gid            => $user_gid,
    home           => "/home/${name}",
    purge_ssh_keys => $user_purge_ssh_keys,
    managehome     => $user_manage_home,
    shell          => '/bin/bash',
    password       => '!',
  }

  $cron_defaults = {
    ensure => present,
    user   => 'root',
  }

  create_resources( user, $users, $user_defaults )
  create_resources( group, $groups, $defaults )
  create_resources( file, $files, $defaults )
  create_resources( cron, $crons, $cron_defaults )
  create_resources( ssh_authorized_key, $sshkeys, $defaults )
  create_resources( profiles::deleted_user, $deleted_users )
  create_resources( yumrepo, $yumrepos )

  # Delete the users before we create the new ones
  #Profiles::Deleted_user <||> -> User <| ensure == present |>
}
