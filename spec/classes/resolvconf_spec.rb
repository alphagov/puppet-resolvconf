require 'spec_helper'

describe 'resolvconf' do
  context 'supported operating systems' do
    ['Debian'].each do |osfamily|
      describe "osfamily is #{osfamily}" do
        let(:facts) {{
          :osfamily => osfamily,
        }}

        describe 'without any params' do
          let(:params) {{ }}
          it { should contain_anchor('resolvconf::begin') }
          it { should contain_class('resolvconf::package') }
          it { should contain_class('resolvconf::config') }
          it { should contain_class('resolvconf::reload') }
          it { should contain_anchor('resolvconf::end') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'resolvconf class without any parameters on CentOS/RedHat' do
      let(:facts) {{
        :osfamily        => 'RedHat',
        :operatingsystem => 'CentOS',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /CentOS not supported/) }
    end
  end
end
