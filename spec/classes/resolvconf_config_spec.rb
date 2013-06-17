require 'spec_helper'

describe 'resolvconf::config', :type => :class do
  let(:file_path) { '/etc/resolvconf/resolv.conf.d/head' }

  context 'use_local' do
    let(:resolv_content) {
      /YOUR CHANGES WILL BE OVERWRITTEN\nnameserver 127.0.0.1$/
    }

    context 'false (default)' do
      let(:params) {{
        :nameservers => ['1.1.1.1', '2.2.2.2'],
      }}

      it { should_not contain_file(file_path).with_content(resolv_content) }
    end

    context 'true, with nameservers' do
      let(:params) {{
        :use_local   => true,
        :nameservers => ['1.1.1.1', '2.2.2.2'],
      }}

      it { should contain_file(file_path).with_content(resolv_content) }
    end

    context 'true, without nameservers' do
      let(:params) {{
        :use_local => true,
      }}

      it { should contain_file(file_path).with_content(resolv_content) }
    end

    context 'true, with dhcp_enabled' do
      let(:facts) {{
        :dhcp_enabled => 'true',
      }}
      let(:params) {{
        :use_local => true,
      }}

      it { should contain_file(file_path).with_content(resolv_content) }
    end
  end

  context 'dhcp_enabled true' do
    let(:facts) {{
      :dhcp_enabled => 'true',
    }}

    context 'override_dhcp false (default)' do
      let(:params) {{
        :nameservers => ['1.1.1.1', '2.2.2.2'],
      }}

      it { should_not contain_file(file_path).with_content(/^nameserver/) }
    end

    context 'override_dhcp true' do
      let(:params) {{
        :override_dhcp => true,
        :nameservers   => ['1.1.1.1', '2.2.2.2'],
      }}

      it { should contain_file(file_path)
        .with_content(/^nameserver 1.1.1.1\nnameserver 2.2.2.2$/)
      }
    end
  end

  context 'dhcp_enabled false' do
    let(:facts) {{ :dhcp_enabled => 'false' }}

    context 'nameservers => []' do
      let(:params) {{ :nameservers => [] }}

      it { should_not contain_file(file_path).with_content(/^nameserver/) }
    end

    [
      '1.1.1.1',
      ['1.1.1.1'],
    ].each do |param|
      context "nameservers => #{param.inspect}" do
        let(:params) {{ :nameservers => param }}

        it { should contain_file(file_path).with_content(/^nameserver 1.1.1.1$/) }
      end
    end

    [
      '1.1.1.1 2.2.2.2',
      ['1.1.1.1', '2.2.2.2']
    ].each do |param|
      context "nameservers => #{param.inspect}" do
        let(:params) {{ :nameservers => param }}

        it { should contain_file(file_path)
          .with_content(/^nameserver 1.1.1.1\nnameserver 2.2.2.2$/)
        }
      end
    end
  end
end
