require 'spec_helper'

describe 'resolvconf::config', :type => :class do
  let(:file_path) { '/etc/resolvconf/resolv.conf.d/head' }
  let(:file_header) { /\A(#[^\n]*\n){2}/ }

  context 'params defaults' do
    let(:params) {{ }}

    it { should contain_file(file_path).with_content(/#{file_header}\Z/) }
  end

  context 'use_local' do
    context 'false (default) with nameservers' do
      let(:params) {{
        :nameservers => ['1.1.1.1'],
      }}

      it { should contain_file(file_path).with_content(
        /#{file_header}nameserver 1\.1\.1\.1\Z/
      )}
    end

    context 'true with nameservers' do
      let(:params) {{
        :use_local   => true,
        :nameservers => ['1.1.1.1'],
      }}

      it { should contain_file(file_path).with_content(
        /#{file_header}nameserver 127\.0\.0\.1\nnameserver 1\.1\.1\.1\Z/
      )}
    end

    context 'true without nameservers' do
      let(:params) {{
        :use_local => true,
      }}

      it { should contain_file(file_path).with_content(
        /#{file_header}nameserver 127\.0\.0\.1\Z/
      )}
    end

    context 'true, even with dhcp_enabled' do
      let(:facts) {{
        :dhcp_enabled => 'true',
      }}
      let(:params) {{
        :use_local => true,
      }}

      it { should contain_file(file_path).with_content(
        /#{file_header}nameserver 127\.0\.0\.1\Z/
      )}
    end
  end

  context 'dhcp_enabled true' do
    let(:facts) {{
      :dhcp_enabled => 'true',
    }}

    context 'override_dhcp false (default)' do
      let(:params) {{
        :nameservers => ['1.1.1.1'],
      }}

      it { should contain_file(file_path).with_content(
        /#{file_header}\Z/
      )}
    end

    context 'override_dhcp true' do
      let(:params) {{
        :override_dhcp => true,
        :nameservers   => ['1.1.1.1'],
      }}

      it { should contain_file(file_path).with_content(
        /#{file_header}nameserver 1\.1\.1\.1\Z/
      )}
    end
  end

  context 'dhcp_enabled false' do
    let(:facts) {{
      :dhcp_enabled => 'false',
    }}

    context 'nameservers => []' do
      let(:params) {{ :nameservers => [] }}

      it { should contain_file(file_path).with_content(/#{file_header}\Z/) }
    end

    [
      '1.1.1.1',
      ['1.1.1.1'],
    ].each do |param|
      context "nameservers => #{param.inspect}" do
        let(:params) {{ :nameservers => param }}

        it { should contain_file(file_path).with_content(
          /#{file_header}nameserver 1\.1\.1\.1\Z/
        )}
      end
    end

    [
      '1.1.1.1 2.2.2.2',
      ['1.1.1.1', '2.2.2.2']
    ].each do |param|
      context "nameservers => #{param.inspect}" do
        let(:params) {{ :nameservers => param }}

        it { should contain_file(file_path).with_content(
          /#{file_header}nameserver 1\.1\.1\.1\nnameserver 2\.2\.2\.2\Z/
        )}
      end
    end
  end
end
