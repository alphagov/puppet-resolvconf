# = Class: resolvconf
#
# Manage nameservers with resolvconf on Debian-alike systems.
#
# == Parameters:
#
# [*nameservers*]
#   Nameservers to favour in the resulting `resolv.conf`.
#   Default: undef, see resolvconf::config
#
class resolvconf(
  $nameservers = undef
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
