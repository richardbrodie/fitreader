require 'yaml'

module Fitreader
  class Static
    @@const ||= YAML::load_file(File.join( File.dirname(__FILE__), 'sdk/constants.yml'))
    @@types ||= YAML::load_file(File.join( File.dirname(__FILE__), 'sdk/types.yml'))

    def self.base
      @@types[:base_types]
    end

    def self.message
      @@types[:message_fields]
    end

    def self.enums
      @@const
    end
  end
end
