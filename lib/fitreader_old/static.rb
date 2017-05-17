require 'yaml'

module Fitreader
  class Static
    @enums ||= YAML::load_file(File.join( File.dirname(__FILE__), 'sdk/constants.yml'))
    @types ||= YAML::load_file(File.join( File.dirname(__FILE__), 'sdk/types.yml'))
    @scope = [:ride, :lap, :interval]

    def self.base
      @types[:base_types]
    end

    def self.message
      @types[:message_fields]
    end

    def self.enums
      @enums
    end

    def self.scope
      @scope
    end
  end
end
