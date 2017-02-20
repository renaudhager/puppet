require 'spec_helper'

describe 'profiles::puppet::facts' do
  let( :params ) {
    {
      :ensure => 'present',
      :static => {
        'toto' => 'tata',
        'tutu' => 'titi',
      },
      :owner  => 'puppet',
      :group  => 'puppet',
      :mode   => '0555',
    }
  }

  context 'with ::kernel => Linux' do
    let( :facts )  { { :kernel => 'Linux' } }

    it { should compile.with_all_deps }

    it do
      should contain_file( '/opt/puppetlabs/facter/facts.d/static.yaml' ).with(
        'ensure'  => 'present',
        'owner'   => 'puppet',
        'group'   => 'puppet',
        'mode'    => '0555', )
    end
  end

  context 'with ::kernel => Windows' do
    let( :facts )  { { :kernel => 'Windows' } }

    it { should_not compile }
  end
end
