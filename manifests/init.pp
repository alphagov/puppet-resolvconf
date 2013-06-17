# = Class: resolvconf
#
# Manage nameservers with resolvconf on Debian-alike systems.
#
# == Parameters:
#
# [*use_local*]
#   See resolvconf::config
#
# [*nameservers*]
#   See resolvconf::config
#
# [*override_dhcp*]
#   See resolvconf::config
#
class resolvconf(
  $use_local = undef,
  $nameservers = undef,
  $override_dhcp = undef
) {
  anchor { 'resolvconf::begin': }

  class { 'resolvconf::package':
    notify  => Class['resolvconf::config'],
    require => Anchor['resolvconf::begin'],
  }

  class { 'resolvconf::config':
    use_local     => $use_local,
    nameservers   => $nameservers,
    override_dhcp => $override_dhcp,
    notify        => Class['resolvconf::reload'],
  }

  class { 'resolvconf::reload':
    notify  => Anchor['resolvconf::end'],
  }

  anchor { 'resolvconf::end': }
}
