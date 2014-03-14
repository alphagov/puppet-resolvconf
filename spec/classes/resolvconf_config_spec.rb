require 'spec_helper'

# Focus on resolvconf::config proxy of resolvconf
describe 'resolvconf' do
  let(:default_facts) {{
    :osfamily => 'Debian',
  }}
  let(:facts) { default_facts }

  let(:file_head) { '/etc/resolvconf/resolv.conf.d/head' }
  let(:file_tail) { '/etc/resolvconf/resolv.conf.d/tail' }
  let(:file_header) { /\A(#[^\n]*\n){2}/ }

  context 'params defaults' do
    let(:params) {{ }}

    it { should contain_class('resolvconf::dpkg_reconfigure') }

    it 'should manage head file' do
      should contain_file(file_head).with(
        :ensure  => 'file',
        :content => /#{file_header}\Z/
      )
    end

    it 'should manage tail file' do
      should contain_file(file_tail).with(
        :ensure  => 'file',
        :content => ''
      )
    end

    context 'Ubuntu 10.04' do
      let(:facts) { default_facts.merge({
        :lsbdistrelease    => '10.04',
        :lsbmajdistrelease => '10',
      })}

      it 'should symlink resolv.conf' do
        should contain_file('/etc/resolv.conf').with(
          :ensure => 'link',
          :target => '/etc/resolvconf/run/resolv.conf'
        )
      end
    end

    context 'Ubuntu 12.04' do
      let(:facts) { default_facts.merge({
        :lsbdistrelease    => '12.04',
        :lsbmajdistrelease => '12',
      })}

      it 'should symlink resolv.conf' do
        should contain_file('/etc/resolv.conf').with(
          :ensure => 'link',
          :target => '../run/resolvconf/resolv.conf'
        )
      end
    end
  end

  context 'resolv.conf.d/head' do

    context 'use_local' do
      context 'false (default) with nameservers' do
        let(:params) {{
          :nameservers => ['1.1.1.1'],
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 1\.1\.1\.1\Z/
        )}
      end

      context 'true with nameservers' do
        let(:params) {{
          :use_local   => true,
          :nameservers => ['1.1.1.1'],
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 127\.0\.0\.1\nnameserver 1\.1\.1\.1\Z/
        )}
      end

      context 'true without nameservers' do
        let(:params) {{
          :use_local => true,
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 127\.0\.0\.1\Z/
        )}
      end

      context 'true, even with dhcp_enabled' do
        let(:facts) { default_facts.merge({
          :dhcp_enabled => 'true',
        })}
        let(:params) {{
          :use_local => true,
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 127\.0\.0\.1\Z/
        )}
      end

      context 'use_local should reject strings' do
        let(:params) {{
          :use_local => 'false',
        }}

        it { expect { should }.to raise_error(Puppet::Error, /is not a boolean/) }
      end
    end

    context 'dhcp_enabled true' do
      let(:facts) { default_facts.merge({
        :dhcp_enabled => 'true',
      })}

      context 'override_dhcp false (default)' do
        let(:params) {{
          :nameservers => ['1.1.1.1'],
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}\Z/
        )}
      end

      context 'override_dhcp true' do
        let(:params) {{
          :override_dhcp => true,
          :nameservers   => ['1.1.1.1'],
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 1\.1\.1\.1\Z/
        )}
      end

      context 'override_dhcp should reject strings' do
        let(:params) {{
          :override_dhcp => 'false',
        }}

        it { expect { should }.to raise_error(Puppet::Error, /is not a boolean/) }
      end
    end

    context 'dhcp_enabled false' do
      let(:facts) { default_facts.merge({
        :dhcp_enabled => 'false',
      })}

      context 'nameservers => []' do
        let(:params) {{ :nameservers => [] }}

        it { should contain_file(file_head).with_content(/#{file_header}\Z/) }
      end

      context "nameservers => ['1.1.1.1']" do
        let(:params) {{
          :nameservers => ['1.1.1.1'],
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 1\.1\.1\.1\Z/
        )}
      end

      context "nameservers => ['1.1.1.1', 2.2.2.2', '3.3.3.3']" do
        let(:params) {{
          :nameservers => ['1.1.1.1', '2.2.2.2', '3.3.3.3'],
        }}

        it { should contain_file(file_head).with_content(
          /#{file_header}nameserver 1\.1\.1\.1\nnameserver 2\.2\.2\.2\nnameserver 3\.3\.3\.3\Z/
        )}
      end

      context 'nameserver should reject strings' do
        let(:params) {{
          :nameservers => '1.1.1.1 2.2.2.2',
        }}

        it { expect { should }.to raise_error(Puppet::Error, /is not an Array/) }
      end
    end

  end

  context 'resolv.conf.d/tail' do

    context 'domain' do
      context 'example.com' do
        let(:params) {{
          :domain => 'example.com',
        }}

        it { should contain_file(file_tail).with_content("domain example.com\n") }
      end

      context 'should reject arrays' do
        let(:params) {{
          :domain => ['foo.example.com', 'bar.example.com'],
        }}

        it { expect { should }.to raise_error(Puppet::Error, /is not a string/) }
      end
    end

    context 'search' do
      context "['foo.example.com', 'bar.example.com']" do
        let(:params) {{
          :search => ['foo.example.com', 'bar.example.com'],
        }}

        it { should contain_file(file_tail).with_content("search foo.example.com bar.example.com\n") }
      end

      context 'should reject strings' do
        let(:params) {{
          :search => 'foo.example.com',
        }}

        it { expect { should }.to raise_error(Puppet::Error, /is not an Array/) }
      end
    end

    context 'domain and search' do
      let(:params) {{
        :domain => 'example.com',
        :search => ['example.com'],
      }}

      it { expect { should }.to raise_error(Puppet::Error, /mutually exclusive/) }
    end

    context 'options' do
      context "['timeout:1', 'attempts:1']" do
        let(:params) {{
          :options => ['timeout:1', 'attempts:1'],
        }}

        it { should contain_file(file_tail).with_content("options timeout:1 attempts:1\n") }
      end

      context 'should reject strings' do
        let(:params) {{
          :search => 'timeout:1',
        }}

        it { expect { should }.to raise_error(Puppet::Error, /is not an Array/) }
      end
    end

  end
end
