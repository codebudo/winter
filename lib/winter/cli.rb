# Copyright 2013 LiveOps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not 
# use this file except in compliance with the License.  You may obtain a copy 
# of the License at:
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
# License for the specific language governing permissions and limitations 
# under the License.

require 'thor'
#autoload :DSL,      'winter/dsl'
require 'winter/dsl'
require 'winter/logger'
require 'winter/version'
require 'winter/service/build'
require 'winter/service/fetch'
require 'winter/service/start'
require 'winter/service/status'
require 'winter/service/stop'
require 'winter/service/validate'

module Winter
  class CLI < Thor

    desc "validate [Winterfile]", "(optional) Check the configuration files"
    method_option :group, :desc => "Config group"
    method_option :debug,   :desc => "Set log level to debug."
    def validate( winterfile='Winterfile' )
      begin
        $LOG.level = Logger::DEBUG if options[:debug]
        s = Winter::Service.new
        s.validate winterfile, options
        $LOG.info "#{winterfile} is valid." 
      rescue Exception=>e
        $LOG.error "#{winterfile} is invalid." 
        $LOG.debug e
      end
    end

    desc "version", "Display version information."
    def version
      $LOG.info VERSION
    end

    desc "start [Winterfile]", "Start the services in [Winterfile] "
    method_option :group,     :desc => "Config group"
    method_option :debug,     :desc => "Set log level to debug."
    method_option :daemonize, :desc => "Keep winter process running to trap system signals."
    method_option :console, :desc => "Send console output to [file]",
      :default => "/dev/null", :aliases => "--con"
    def start(winterfile='Winterfile')
      $LOG.level = Logger::DEBUG if options[:debug]
      s = Winter::Service.new
      s.start winterfile, options
    end

    desc "stop [Winterfile]", "Stop the services in [Winterfile]"
    method_option :group,   :desc => "Config group"
    def stop(winterfile='Winterfile')
      s = Winter::Service.new
      s.stop winterfile, options
    end

    desc "status", "Show status of available services"
    def status
      running = 0
      s = Winter::Service.new
      s.status.each do |service, status|
        $LOG.info " #{service} : #{status}"
        running += 1 if status =~ /Running/i
      end
      $LOG.info "#{running} services are running."
    end

    desc "build [Winterfile]", "Build a service from a Winterfile"
    method_option :group,   :desc => "Config group"
    method_option :verbose, :desc => "Verbose maven output"
    method_option :debug,   :desc => "Set log level to debug."
    method_option :clean,   :desc => "Remove all artifacts before building."
    method_option :local,   :desc => "Resolve dependencies only from local repository"
    def build( winterfile='Winterfile' )
      $LOG.level = Logger::DEBUG if options[:debug]
      s = Winter::Service.new
      s.build( winterfile, options )
    end

    desc "fetch <URL|GROUP> [artifact] [version]", "Download the Winterfile and configuration from a URL."
    method_option :debug, :desc => "Set log level to debug."
    method_option :repositories, :desc => "Comma separated list of repositories to search.", :default => '', :aliases => "--repos"
    def fetch( url_or_group, artifact=nil, version='LATEST' )
      $LOG.level = Logger::DEBUG if options[:debug]
      s = Winter::Service.new
      if( url_or_group =~ /^http:/ ) 
        s.fetch_url url_or_group
      #elsif( !url_or_group.nil? && !artifact.nil? && !version.nil? )
      elsif( !artifact.nil? )
        repos = options[:repositories] || ''
        repos = repos.split(',') 
        s.fetch_GAV url_or_group, artifact, version, repos
      else
        $LOG.error "Invalid arguments. See `winter help fetch`."
      end
    end

  end #class
end #module

