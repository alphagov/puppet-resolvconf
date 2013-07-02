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
# [*domain*]
#   See resolvconf::config
#
# [*search*]
#   See resolvconf::config
#
# [*options*]
#   See resolvconf::config
#
# [*override_dhcp*]
#   See resolvconf::config
#
class resolvconf(
  $use_local = undef,
  $nameservers = undef,
  $domain = undef,
  $search = undef,
  $options = undef,
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
    domain        => $domain,
    search        => $search,
    options       => $options,
    override_dhcp => $override_dhcp,
    notify        => Class['resolvconf::reload'],
  }

  class { 'resolvconf::reload':
    notify  => Anchor['resolvconf::end'],
  }

  anchor { 'resolvconf::end': }
}
