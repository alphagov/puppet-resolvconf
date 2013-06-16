# == Class: resolvconf::config
#
# Configure nameservers by appending them to `resolv.conf.d/head` which
# ensures they will always come first.
#
# Using this rather brute force method, instead of `interfaces(5)`, because
# it requires no other parsing or knowledge about the network configuration.
#
# If the `$::dhcp_enabled` fact is true it will not append anything.
#
class resolvconf::config(
  $nameservers = []
) {
  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure  => present,
    content => template('resolvconf/etc/resolvconf/resolv.conf.d/head.erb'),
  }
}
