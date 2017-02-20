require 'spec_helper'

describe 'profiles::bind::server' do
  let( :params ) {
    {
      :confs => {
        '/etc/named.conf' => {
          'listen_on_addr'  => ['any'],
          'forwarders'      => ['172.16.8.2'],
          'allow_query'     => ['172.16.8.0/24', '127.0.0.1'],
          'allow_recursion' => ['172.16.8.0/24', '127.0.0.1'],
          'zones'           => {
            'consul' =>[
              'type forward',
              'forward only',
              'forwarders { 127.0.0.1 port 8600; }'
            ]
          }

        }
      },
    }
  }

  context 'with ::osfamily => RedHat' do
    let( :facts )  { { :osfamily => 'RedHat' } }
    it { should compile.with_all_deps }
    it do
      should contain_bind_server_conf('/etc/named.conf')
    end
  end

end
