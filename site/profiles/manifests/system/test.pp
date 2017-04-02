# profiles::system::test
#
#
class profiles::system::test (

) {

  $system_role  = hiera('system_role', 'N/A')
  notify{'system_role':
    message => "system_role is ${system_role}"
  }

}
