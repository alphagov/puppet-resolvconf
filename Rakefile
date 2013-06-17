require 'rspec/core/rake_task'

# Ignore vendored code.
exclude_paths = ["vendor/**/*"]

require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths = exclude_paths

require 'puppet-syntax/tasks/puppet-syntax'
PuppetSyntax.exclude_paths = exclude_paths

task :default => [
  :syntax,
  :lint,
]
