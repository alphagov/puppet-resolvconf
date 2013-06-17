# Ignore vendored code.
exclude_paths = ["vendor/**/*"]

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths = exclude_paths

require 'puppet-syntax/tasks/puppet-syntax'
PuppetSyntax.exclude_paths = exclude_paths

task :default => [
  :syntax,
  :lint,
  :spec,
]
