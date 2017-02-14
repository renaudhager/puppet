# profiles::system::dhclient
#
# This class manages dhclient configuration on nodes
# This is an hack for aws provisioning.
#

class profiles::system::dhclient (
  String $dhclient_file     = '/etc/dhcp/dhclient.conf',
  String $dhclient_content  = 'undef',
  Boolean $disable_dhclient = true,
  String $dhclient_process  = 'dhclient',
)  {

  if $dhclient_content != 'undef' {
    file { $dhclient_file:
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $dhclient_content,
    }
  }

  if $disable_dhclient {
    exec { 'kill_dhclient':
      command => "ps -ef | grep ${dhclient_process} | grep -v grep | awk '{print \$2}' | xargs kill",
      onlyif  => "ps -ef | grep ${dhclient_process} | grep -v grep",
    }
  }

}
