module Fitreader
  class MessageType
    attr_reader :definition, :records
    attr_accessor :undefined_records

    def initialize(definition)
      @definition = definition
      @records = []
      @undefined_records = []
    end
  end
end
