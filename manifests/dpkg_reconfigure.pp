# == Class: resolvconf::dpkg_reconfigure
#
# Call `dpkg-reconfigure resolvconf` to setup `/run/resolvconf/resolv.conf`.
#
# This should be notified after changes to `/etc/resolv.conf`, which should
# be a symlink to the aforementioned file. If called before it will refuse
# to run.
#
class resolvconf::dpkg_reconfigure {
  exec { 'dpkg-reconfigure resolvconf':
    command     => '/usr/sbin/dpkg-reconfigure -f noninteractive resolvconf',
    refreshonly => true,
  }
}
