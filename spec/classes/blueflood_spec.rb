require 'spec_helper'

describe 'blueflood' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        default_jar_file  = '/opt/blueflood/bin/blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar'
        # default_jar_file  = '/opt/blueflood/bin/jar.txt'
        default_configuration_file  = '/opt/blueflood/config/blueflood.properties'
        default_logging_configuration_file = '/opt/blueflood/config/log4j.properties'

        describe "blueflood with default settings on #{osfamily}" do
           let(:params) {{
            # :service_config_file => 'undef',
          }}
          # We must mock $::operatingsystem because otherwise this test will
          # fail when you run the tests on e.g. Mac OS X.
          it { should compile.with_all_deps }

          it { should contain_class('blueflood::params') }
          it { should contain_class('blueflood') }
          it { should contain_class('blueflood::users').that_comes_before('blueflood::install') }
          it { should contain_class('blueflood::install').that_comes_before('blueflood::config') }
          it { should contain_class('blueflood::config') }
          it { should contain_class('blueflood::service').that_subscribes_to('blueflood::config') }

         # it { should contain_package('blueflood').with_ensure('present') }

         it { should contain_group('blueflood').with({
           'ensure'     => 'present',
           'gid'        => 53073,
         })}

         it { should contain_user('blueflood').with({
           'ensure'     => 'present',
           'home'       => '/home/blueflood',
           'shell'      => '/bin/bash',
           'uid'        => 53073,
           'comment'    => 'Blueflood system account',
           'gid'        => 'blueflood',
           'managehome' => true,
         })}


          it { should contain_file(default_jar_file).with({
            'ensure' => 'file',
            'owner'  => 'blueflood',
            'group'  => 'blueflood',
            'mode'   => '0755',
          })}

         # it { should contain_file('/opt/blueflood/logs').with({
         #   'ensure' => 'directory',
         #   'owner'  => 'blueflood',
         #   'group'  => 'blueflood',
         #   'mode'   => '0644',
         # })}

         it { should contain_file('/var/log/blueflood').with({
           'ensure' => 'directory',
           'owner'  => 'blueflood',
           'group'  => 'blueflood',
           'mode'   => '0644',
         })}

         it { should contain_file(default_configuration_file).with({
             'ensure' => 'file',
             'owner'  => 'blueflood',
             'group'  => 'blueflood',
             'mode'   => '0644',
           })
           .with_content(/^CASSANDRA_HOSTS=127.0.0.1:9160$/)
           .with_content(/^DEFAULT_CASSANDRA_PORT=9160$/)
         }
         #it { should contain_file(default_logging_configuration_file).with({
         #    'ensure' => 'file',
         #    'owner'  => 'blueflood',
         #    'group'  => 'blueflood',
         #    'mode'   => '0644',
         #  })
         #
         #}
         
          it { should contain_supervisor__service('blueflood').with({
            'ensure'      => 'present',
            'enable'      => true,
            # 'command'     => '/opt/kafka/bin/kafka-run-class.sh kafka.Kafka /opt/kafka/config/server.properties',
            # 'environment' => """JMX_PORT=9999,KAFKA_GC_LOG_OPTS=\"-Xloggc:/var/log/kafka/daemon-gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps\",KAFKA_HEAP_OPTS=\"-Xmx256M\",KAFKA_JMX_OPTS=\"-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false\",KAFKA_JVM_PERFORMANCE_OPTS=\"-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true\",KAFKA_LOG4J_OPTS=\"-Dlog4j.configuration=file:/opt/kafka/config/log4j.properties\",""",
            'user'        => 'blueflood',
            'group'       => 'blueflood',
            'autorestart' => true,
            'startsecs'   => 10,
            'retries'     => 999,
            'stopsignal'  => 'INT',
            'stopasgroup' => true,
            'stopwait'    => 120,
            'stdout_logfile_maxsize' => '20MB',
            'stdout_logfile_keep'    => 5,
            'stderr_logfile_maxsize' => '20MB',
            'stderr_logfile_keep'    => 10,
          })}
        end

      

        describe "kafka with disabled user management on #{osfamily}" do
          let(:params) {{
            :user_manage  => false,
          }}
          it { should_not contain_group('blueflood') }
          it { should_not contain_user('blueflood') }
        end

        describe "blueflood with custom user and group on #{osfamily}" do
          let(:params) {{
            :user_manage      => true,
            :gid              => 456,
            :group            => 'bluefloodgroup',
            :uid              => 123,
            :user             => 'blueflooduser',
            :user_description => 'Blueflood user',
            :user_home        => '/home/blueflooduser',
          }}

          it { should_not contain_group('blueflood') }
          it { should_not contain_user('blueflood') }

          it { should contain_user('blueflooduser').with({
            'ensure'     => 'present',
            'home'       => '/home/blueflooduser',
            'shell'      => '/bin/bash',
            'uid'        => 123,
            'comment'    => 'Blueflood user',
            'gid'        => 'bluefloodgroup',
            'managehome' => true,
          })}

          it { should contain_group('bluefloodgroup').with({
            'ensure'     => 'present',
            'gid'        => 457,
          })}
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'blueflood without any parameters on Debian' do
      let(:facts) {{
        :osfamily => 'Debian',
      }}

      it { expect { should contain_class('blueflood') }.to raise_error(Puppet::Error,
        /The blueflood module is not supported on a Debian based system./) }
    end
  end
end
