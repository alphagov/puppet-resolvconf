require 'spec_helper'

describe 'resolvconf' do
  context 'pass params to resolvconf::config' do
    context 'defer to defaults in sub-class' do
      let(:params) {{ }}

      it { should contain_class('resolvconf::config').with(
        :use_local     => false,
        :nameservers   => [],
        :domain        => '',
        :search        => [],
        :options       => [],
        :override_dhcp => false
      )}
    end

    context 'pass custom values to sub-class' do
      {
        :domain => {
          :use_local     => true,
          :nameservers   => ['1.1.1.1'],
          :domain        => 'example.com',
          :options       => ['timeout:1'],
          :override_dhcp => true,
        },
        :search => {
          :use_local     => true,
          :nameservers   => ['1.1.1.1'],
          :search        => ['example.com'],
          :options       => ['timeout:1'],
          :override_dhcp => true,
        },
      }.each do |key, vals|
        context key do
          let(:params) { vals }

          it { should contain_class('resolvconf::config').with(vals)}
        end
      end
    end
  end
end
