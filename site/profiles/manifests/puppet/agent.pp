# profiles::puppet::agent
#
# This class configure puppet agent
#
#
# TODO : Make Unt tests
class profiles::puppet::agent (

) {

  puppet::setting { 'certname':
    section => 'main',
    value   => $trusted['certname'],
  }

}
