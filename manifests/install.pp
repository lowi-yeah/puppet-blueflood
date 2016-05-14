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

  exec { 'download-blueflood':
    path    => ['/usr/bin'],
    command => 'curl -s -L https://github.com/rackerlabs/blueflood/releases/latest | egrep -o \'rackerlabs/blueflood/releases/download/rax-release-.*/blueflood-all-.*-jar-with-dependencies.jar\' |  xargs -I % curl -C - -L https://github.com/% --create-dirs -o blueflood-all/target/blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar',
    creates => "$base_dir/blueflood-all/target/blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar",
    cwd     => $base_dir
  }
}