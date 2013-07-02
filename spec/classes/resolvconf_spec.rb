require 'spec_helper'

describe 'resolvconf' do
  context 'pass params to resolvconf::config' do
    context 'defer to defaults in sub-class' do
      let(:params) {{ }}

      it { should contain_class('resolvconf::config').with(
        :use_local     => false,
        :nameservers   => [],
        :override_dhcp => false
      )}
    end

    context 'pass custom values to sub-class' do
      let(:params) {{
        :use_local     => true,
        :nameservers   => ['1.1.1.1'],
        :override_dhcp => true,
      }}

      it { should contain_class('resolvconf::config').with(
        :use_local     => true,
        :nameservers   => ['1.1.1.1'],
        :override_dhcp => true
      )}
    end
  end
end
