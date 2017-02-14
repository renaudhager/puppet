# profiles::puppet::ca
#
# This class configure puppet ca
#
# TODO : Make Unt tests
class profiles::puppet::ca (
) {

  # Deploy autosign script
  # file{ '/etc/puppetlabs/puppet/autosign.bash':
  #   ensure => 'present',
  #   owner  => 'puppet',
  #   group  => 'puppet',
  #   mode   => '0744',
  #   source => 'puppet:///modules/profiles/puppet/ca/autosign.bash',
  #   notify => Service['puppetserver'],
  # }

}
