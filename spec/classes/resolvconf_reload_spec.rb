require 'spec_helper'

describe 'resolvconf::reload' do
  it { should contain_exec('/sbin/resolvconf -u').with(
    :refreshonly => true
  )}
end
