require 'thor'
require_relative 'dsl'

module Winter
  class CLI < Thor

    desc "validate", "Check the configuration files"
    def validate( winterfile='Winterfile' )
      DSL.evaluate winterfile
    end

  end #class
end #module

