# profiles::puppet::facts
#
# This class manages static facts
#
class profiles::puppet::facts (
  String $ensure = 'present',
  Hash $static   = {},
  String $owner  = 'root',
  String $group  = 'root',
  String $mode   = '0644',
)  {

  case $::kernel {
    'Linux': {
      file { '/opt/puppetlabs/facter/facts.d/static.yaml':
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        content => template( "${module_name}/puppet/facts/template.erb" ),
      }
    }
    default: {
      fail( 'Unsupported Kernel' )
    }
  }
}
