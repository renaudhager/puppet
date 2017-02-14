# profiles::system::dnsmasq
#
# This class manages DNSMASQ configuration on nodes
#
# Required modules :
# - saz/dnsmasq
#
class profiles::system::dnsmasq (
  Hash $conf = {},
  Array $upstream_server = [],
)  {
  # Deep Merge bug
  $dnsmasq_conf = hiera_hash( 'profiles::system::dnsmasq::conf', {} )

  $defaults = {
    ensure => present,
  }

  create_resources( dnsmasq::conf, $dnsmasq_conf, $defaults )

  file { '/etc/default/dnsmasq':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file( 'profiles/system/dnsmasq/dnsmasq.default' ),
    notify  => Service['dnsmasq'],
  }

  file { '/etc/dnsmasq_resolv.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template( 'profiles/system/dnsmasq/resolv.erb' ),
    notify  => Service['dnsmasq'],
  }

}
