require 'spec_helper'

describe 'profiles::puppet::server' do


  context 'Checking if configuration files are correctly configured :' do

    let :pre_condition do
      'class {"::puppet::profile::master":
        manage_hiera_config        => false,
        manage_hiera_eyaml_package => false,
      }'
    end

    let( :facts )  {
      { :osfamily      => 'RedHat',
        :puppetversion => '4.7.0',
      }
    }

    it { should compile.with_all_deps }

    it do
      should contain_file( '/etc/puppetlabs/code/hiera.yaml' ).with(
        'owner'   => 'root',
        'group'   => 'root', )

      should contain_file( '/etc/puppetlabs/puppetserver/conf.d/webserver.conf' ).with(
        'owner'   => 'root',
        'group'   => 'root', )

      should contain_file( '/etc/puppetlabs/puppet/autosign.conf' ).with(
        'owner'   => 'root',
        'group'   => 'root', )

      should contain_file( '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/vendor/deep_merge/lib/deep_merge/core.rb' ).with(
        'owner'   => 'root',
        'group'   => 'root', )

      should contain_file( '/usr/local/bin/r10-deploy.bash' ).with(
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0744', )

      should contain_file( '/var/log/puppetlabs/r10k/' ).with(
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755', )

      should contain_cron( 'r10-deploy' ).with(
        'ensure'  => 'present',
        'command' => '/usr/local/bin/r10-deploy.bash',
        'user'    => 'root',
        'hour'    => '["*"]',
        'minute'    => '*/2',)

    end
  end

end
