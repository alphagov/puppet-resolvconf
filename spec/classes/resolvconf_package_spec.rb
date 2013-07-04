require 'spec_helper'

describe 'resolvconf::package' do
  it { should contain_package('resolvconf').with_ensure('present') }
end
