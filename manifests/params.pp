# == Class blueflood::params
#
# This class is meant to be called from blueflood.
# It sets variables according to platform.
#
class blueflood::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'blueflood'
      $service_name = 'blueflood'
    }
    'RedHat', 'Amazon': {
      $package_name = 'blueflood'
      $service_name = 'blueflood'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
  $blueflood_group = 'root'
  $blueflood_user = 'root'
  $install_location = '/etc/blueflood'
}
