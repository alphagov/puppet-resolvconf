# = Class: resolvconf::reload
#
# Regenerate `resolv.conf` due to changes in `resolv.conf.d`.
#
class resolvconf::reload {
  exec { '/sbin/resolvconf -u':
    refreshonly => true,
  }
}
