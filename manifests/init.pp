# Class: blueflood
# ===========================
#
# Full description of class blueflood here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class blueflood (
  $package_name = $::blueflood::params::package_name,
  $service_name = $::blueflood::params::service_name,
) inherits ::blueflood::params {

  # validate parameters here

  class { '::blueflood::install': } ->
  class { '::blueflood::config': } ~>
  class { '::blueflood::service': } ->
  Class['::blueflood']
}
