# = Class: resolvconf
#
# Manage nameservers with resolvconf on Debian-alike systems.
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
class resolvconf(
  $use_local = false,
  $nameservers = [],
  $domain = '',
  $search = [],
  $options = [],
  $override_dhcp = false
) {
  if ($::osfamily != 'Debian') {
    fail("${::operatingsystem} not supported")
  }

  anchor { 'resolvconf::begin': } ->
  class { 'resolvconf::package': } ->
  class { 'resolvconf::config': } ~>
  class { 'resolvconf::reload': } ~>
  anchor { 'resolvconf::end': }

  Anchor['resolvconf::begin']  ~> Class['resolvconf::reload']
  Class['resolvconf::package'] ~> Class['resolvconf::reload']
}
