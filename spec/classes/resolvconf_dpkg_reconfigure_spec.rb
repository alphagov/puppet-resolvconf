require 'spec_helper'

describe 'resolvconf::dpkg_reconfigure' do
  it { should contain_exec('dpkg-reconfigure resolvconf').with(
    :command     => '/usr/sbin/dpkg-reconfigure -f noninteractive resolvconf',
    :refreshonly => 'true'
  )}
end
