source 'https://rubygems.org'

# Versions can be overridden with environment variables for matrix testing.

gem 'puppet', ENV['PUPPET_VERSION'] || '~> 4.9'

if RUBY_VERSION =~ /^1/
  gem 'rake', '<=10.1.0'
else
  gem 'rake'
end

gem 'puppet-lint'
gem 'puppet-syntax'
gem 'puppetlabs_spec_helper'
gem 'rspec-puppet'
gem 'rspec-system-puppet'
