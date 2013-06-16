# = Class: resolvconf::package
#
# Install the resolvconf package.
#
class resolvconf::package {
  package { 'resolvconf':
    ensure => present,
  }
}
