require 'yaml'

module Fitreader
  class Static
    @@const ||= YAML::load_file(File.join( File.dirname(__FILE__), 'sdk/constants.yml'))
    @@types ||= YAML::load_file(File.join( File.dirname(__FILE__), 'sdk/types.yml'))

    def self.const
      @@const
    end

    def self.types
      @@types
    end
  end
end
