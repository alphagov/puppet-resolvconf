# = Class: resolvconf::config
#
# Takes two types of configuration:
#
# - nameservers are appended to `resolv.conf.d/head` to ensure that they
#   always come first.
# - domain, search, and options, are appended to `resolv.conf.d/tail` to
#   ensure that they come last.
#
# Using this rather brute force method, instead of `interfaces(5)`, because
# it requires no other parsing or knowledge about the network configuration.
#
class resolvconf::config(
) {
  $use_local     = $::resolvconf::use_local
  $nameservers   = $::resolvconf::nameservers
  $domain        = $::resolvconf::domain
  $search        = $::resolvconf::search
  $options       = $::resolvconf::options
  $override_dhcp = $::resolvconf::override_dhcp

  if ($domain != '') and ($search != []) {
    fail('The domain and search params are mutually exclusive')
  }

  validate_bool($use_local, $override_dhcp)
  validate_array($nameservers, $search, $options)
  validate_string($domain)

  include resolvconf::dpkg_reconfigure

  $resolv_conf_target = $::lsbmajdistrelease ? {
    /^1[0-1]$/ => '/etc/resolvconf/run/resolv.conf',
    default     => '../run/resolvconf/resolv.conf',
  }

  file { '/etc/resolv.conf':
    ensure => link,
    target => $resolv_conf_target,
    notify => Class['resolvconf::dpkg_reconfigure'],
  }

  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => file,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/head.erb'),
  }

  file { '/etc/resolvconf/resolv.conf.d/tail':
    ensure  => file,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/tail.erb'),
  }
}
