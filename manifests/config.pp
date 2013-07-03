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
# == Parameters:
#
# [*use_local*]
#   Prepend `127.0.0.1` to the list of nameservers to prefer a local caching
#   forwarder like dnsmasq.
#   Default: false
#
# [*nameservers*]
#   Nameservers to favour in the resulting `resolv.conf`.
#   Default: []
#
# [*domain*]
#   String value for `domain` in `resolv.conf(5)`. This is mutually
#   exclusive to the `search` param.
#   Default: ''
#
# [*search*]
#   Array of values for `search` in `resolv.conf(5)`. This is mutually
#   exclusive to the `domain` param.
#   Default: []
#
# [*options*]
#   Array of values for `options` in `resolv.conf(5)`.
#   Default: []
#
# [*override_dhcp*]
#   Whether nameservers should be prepended when the `dhcp_enabled` fact is
#   true. Will supersede nameservers provided by DHCP.
#   Default: false
#
#
class resolvconf::config(
  $use_local = false,
  $nameservers = [],
  $domain = '',
  $search = [],
  $options = [],
  $override_dhcp = false
) {
  if ($domain != '') and ($search != []) {
    fail('The domain and search params are mutually exclusive')
  }

  validate_bool($use_local, $override_dhcp)
  validate_array($nameservers, $search, $options)
  validate_string($domain)

  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => present,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/head.erb'),
  }

  file { '/etc/resolvconf/resolv.conf.d/tail':
    ensure  => present,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/tail.erb'),
  }
}
