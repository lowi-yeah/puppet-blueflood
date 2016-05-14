require 'spec_helper'

describe 'blueflood' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        default_broker_configuration_file  = '/opt/blueflood/config/blueflood.properties'
        default_logging_configuration_file = '/opt/blueflood/config/log4j.properties'

        describe "kafka with default settings on #{osfamily}" do
          let(:params) {{ }}
          # We must mock $::operatingsystem because otherwise this test will
          # fail when you run the tests on e.g. Mac OS X.
          it { should compile.with_all_deps }

          it { should contain_class('blueflood::params') }
          it { should contain_class('blueflood') }
          it { should contain_class('blueflood::users').that_comes_before('blueflood::install') }
          it { should contain_class('blueflood::install').that_comes_before('blueflood::config') }
          it { should contain_class('blueflood::config') }
          it { should contain_class('blueflood::service').that_subscribes_to('blueflood::config') }

          it { should contain_package('blueflood').with_ensure('present') }

          it { should contain_group('blueflood').with({
            'ensure'     => 'present',
            'gid'        => 53072,
          })}

          it { should contain_user('blueflood').with({
            'ensure'     => 'present',
            'home'       => '/home/blueflood',
            'shell'      => '/bin/bash',
            'uid'        => 53072,
            'comment'    => 'Blueflood system account',
            'gid'        => 'blueflood',
            'managehome' => true,
          })}

          it { should contain_file('/opt/blueflood/logs').with({
            'ensure' => 'directory',
            'owner'  => 'blueflood',
            'group'  => 'blueflood',
            'mode'   => '0755',
          })}

          it { should contain_file('/var/log/blueflood').with({
            'ensure' => 'directory',
            'owner'  => 'blueflood',
            'group'  => 'blueflood',
            'mode'   => '0755',
          })}

          it { should contain_file(default_broker_configuration_file).with({
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            }).
            with_content(/^broker.id=0$/).
            with_content(/^port=9092$/).
            with_content(/^log.dirs=\/app\/kafka\/log$/).
            with_content(/^zookeeper.connect=localhost:2181$/)
          }

          it { should contain_file(default_logging_configuration_file).with({
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            }).
            with_content(/^log4j.appender.kafkaAppender.File=\/var\/log\/kafka\/server.log$/).
            with_content(/^log4j.appender.stateChangeAppender.File=\/var\/log\/kafka\/state-change.log$/).
            with_content(/^log4j.appender.requestAppender.File=\/var\/log\/kafka\/kafka-request.log$/).
            with_content(/^log4j.appender.controllerAppender.File=\/var\/log\/kafka\/controller.log$/)
          }

          # it { should contain_file('kafka-log-directory-/app/kafka/log').with({
          #   'ensure'       => 'directory',
          #   'path'         => '/app/kafka/log',
          #   'owner'        => 'kafka',
          #   'group'        => 'kafka',
          #   'mode'         => '0750',
          #   'recurse'      => true,
          #   'recurselimit' => 0,
          # })}

         
          it { should contain_supervisor__service('blueflood-db').with({
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
            :user             => 'bluefloodauser',
            :user_description => 'Blueflood user',
            :user_home        => '/home/blueflooduser',
          }}

          it { should_not contain_group('blueflood') }
          it { should_not contain_user('blueflood') }

          it { should contain_user('bluefloodauser').with({
            'ensure'     => 'present',
            'home'       => '/home/bluefloodauser',
            'shell'      => '/bin/bash',
            'uid'        => 123,
            'comment'    => 'Blueflood user',
            'gid'        => 'bluefloodgroup',
            'managehome' => true,
          })}

          it { should contain_group('bluefloodgroup').with({
            'ensure'     => 'present',
            'gid'        => 456,
          })}
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'kafka without any parameters on Debian' do
      let(:facts) {{
        :osfamily => 'Debian',
      }}

      it { expect { should contain_class('kafka') }.to raise_error(Puppet::Error,
        /The kafka module is not supported on a Debian based system./) }
    end
  end
end
