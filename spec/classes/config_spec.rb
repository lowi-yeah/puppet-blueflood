require 'spec_helper'

describe 'blueflood', :type => :class do
  let(:title) { 'blueflood::config' }
  let(:facts) { { :osfamily => 'RedHat' } }

  let(:log_dir) { '/etc/blueflood/logs' }
  let(:log_link) { '/var/log/blueflood' }
  let(:blue_props) { '/etc/blueflood/blueflood.properties' }
  let(:blue_log4j) { '/etc/blueflood/blueflood-log4j.properties' }
  let(:blue_run) { '/etc/blueflood/run.sh' }
  let(:facts) {{ :operatingsystem => 'CentOS', :osfamily => 'RedHat', :lsbmajdistrelease => '6', :ipaddress => '192.168.1.1', }}
  it { should contain_file(log_dir).with_ensure('directory') }
  it { should contain_file(log_link).with_ensure('link').with_target(log_dir) }
  it { should contain_file(blue_props).with_ensure('present') }
  it { should contain_file(blue_log4j).with_ensure('present') }
  it { should contain_file(blue_run).with_ensure('present') }
end
