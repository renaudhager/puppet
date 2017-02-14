# profiles::puppetdb::db
#
# This class manage some extra parameters to configure DB connection
# for puppetdb
#
# Required modules :
# - puppetlabs/inifile
#

class profiles::puppetdb::db (
  String $maximum_pool_size = '5',
  String $conf_file_path = '/etc/puppetlabs/puppetdb/conf.d/database.ini'
)  {


  Ini_setting {
    path    => $conf_file_path,
    ensure  => present,
    section => 'database',
  }

  ini_setting {'puppetdb_maximum_pool_size':
    setting => 'maximum-pool-size',
    value   => $maximum_pool_size,
    notify  => Service['puppetdb'],
  }

}
