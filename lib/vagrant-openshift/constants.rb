#--
# Copyright 2013 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++
require 'pathname'

module Vagrant
  module Openshift
    class Constants
      def self.repos
        {
          'origin-server' => 'https://github.com/openshift/origin-server.git',
          'rhc' => 'https://github.com/openshift/rhc.git',
          'puppet-openshift_origin' => 'https://github.com/openshift/puppet-openshift_origin.git'
        }
      end

      def self.build_dir
        Pathname.new "/data"
      end

      def self.deps_marker
        Pathname.new "/.origin_deps_installed"
      end

      def self.git_ssh
        ""
      end

      def self.restart_services_cmd
        services = [ 'mongod', 'mcollective', 'activemq', 'cgconfig', 'cgred', 'named',
                     'openshift-broker', 'openshift-console', 'openshift-node-web-proxy',
                     'sshd', 'httpd' ]
        cmd = []
        cmd += services.map do |service|
          "/sbin/service #{service} stop;"
        end
        cmd += services.map do |service|
          "/sbin/service #{service} start;"
        end
        cmd << "rm -rf /var/www/openshift/broker/tmp/cache/*;"
        cmd << "/etc/cron.minutely/openshift-facts;"
        cmd << "/sbin/service openshift-tc reload;"
        cmd << "/sbin/service network restart || /sbin/service network reload;"
        cmd << "/sbin/service messagebus restart;"
        cmd << "/sbin/service oddjobd restart;"

        cmd
      end
    end
  end
end