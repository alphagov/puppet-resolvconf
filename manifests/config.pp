# = Class: resolvconf::config
#
# Configure nameservers by appending them to `resolv.conf.d/head` which
# ensures they will always come first.
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
# [*override_dhcp*]
#   Whether nameservers should be prepended when the `dhcp_enabled` fact is
#   true. Will supersede nameservers provided by DHCP.
#   Default: false
#
#
class resolvconf::config(
  $use_local = false,
  $nameservers = [],
  $override_dhcp = false
) {
  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => present,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/head.erb'),
  }
}
