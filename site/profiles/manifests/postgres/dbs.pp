# profiles::postgres::dbs
#
# This class manages pg db creation
#
# Required modules :
# - puppetlabs/postgresql
#

class profiles::postgres::dbs (
  String $db_name     = 'undef',
  String $db_user     = 'undef',
  String $db_password = 'undef',

)  {

  if ( $db_name != 'undef' ) and ( $db_user != 'undef' ) and ( $db_password != 'undef')
  {
    postgresql::server::db { $db_name:
      user     => $db_user,
      password => postgresql_password($db_password, $db_password),
    }
  }
  else {
    fail('Error missing : db_name or db_user or db_password')
  }
}
