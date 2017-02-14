

Exec {
  path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin',
}

# Regex on hostname to determine the role of the node
if empty( hiera( 'role', undef ) )
{
  case $::hostname {
    /compute-sl\d\d$/:       { $role = 'mesos-slave' }
    /compute-ma\d\d$/:       { $role = 'mesos-master' }
    /puppetdb-pgsql-\d\d$/:  { $role = 'puppetdb-pgsql' }
    /nginx-\d\d$/:           { $role = 'nginx' }
    /puppetca-\d\d$/:        { $role = 'puppetca' }
    /puppetmaster-\d\d$/:    { $role = 'puppetmaster' }
    /puppetdb-\d\d$/:        { $role = 'puppetdb' }
    /util-nginx\d\d$/:       { $role = 'nginx' }
    /util-puppetdb\d\d$/:    { $role = 'puppetdb' }
    default:                 { $role = undef }
  }
}
else {
  $role = hiera( 'role' )
}

# Assign DC
# based on certificat domain.
# IE : node1.ue2.aws => datacenter is ue2
if empty( hiera( 'datacenter', undef ) )
{
  $domain_infos = split( $trusted['domain'], '[.]' )
  case $domain_infos[0] {
    'ew1':   { $datacenter = 'ew1' }
    'ue2':   { $datacenter = 'ue2' }
    'vgt':   { $datacenter = 'vgt' }
    default: { fail( 'Datacenter information is missing.' ) }
  }
  # }
}
else {
  $datacenter = hiera( 'datacenter' )
}

node default {
  hiera_hash('include')['classes'].each |$c| { if $c !~ /^--/ and ! defined( Class[$c] ) { include $c } }
}
