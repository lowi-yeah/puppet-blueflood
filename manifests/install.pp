# == Class blueflood::install
#
# This class is called from blueflood for install.
#
class blueflood::install inherits blueflood {

  vcsrepo { $base_dir:
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/rackerlabs/blueflood.git',
  }

 file { $jar_dir:
    ensure  => directory,
    owner   => $blueflood::user,
    group   => $blueflood::group,
    mode    => '0644',
    require => Vcsrepo[$base_dir],
  }

  exec { 'download-blueflood':
    path    => ['/usr/bin'],
    command => "curl ${jar_file}  --output ${jar}",
    creates => $jar,
    cwd     => $base_dir,
    require => Vcsrepo[$base_dir],
  }
}