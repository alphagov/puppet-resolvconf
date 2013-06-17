# = Class: resolvconf
#
# Manage nameservers with resolvconf on Debian-alike systems.
#
# == Parameters:
#
# [*nameservers*]
#   See resolvconf::config
#
# [*override_dhcp*]
#   See resolvconf::config
#
class resolvconf(
  $nameservers = undef,
  $override_dhcp = undef
) {
  anchor { 'resolvconf::begin': }

  class { 'resolvconf::package':
    notify  => Class['resolvconf::config'],
    require => Anchor['resolvconf::begin'],
  }

  class { 'resolvconf::config':
    nameservers => $nameservers,
    notify      => Class['resolvconf::reload'],
  }

  class { 'resolvconf::reload':
    notify  => Anchor['resolvconf::end'],
  }

  anchor { 'resolvconf::end': }
}
