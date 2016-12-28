module Fitreader
  class MessageType
    attr_reader :definition, :records
    attr_accessor :undefined_records

    def initialize(definition)
      @definition = definition
      @records = []
      @undefined_records = []
    end

    def record_values
      records.flatten
             .collect { |y|y.fields.values.collect { |z| [z.name, z.value] } }
             .collect(&:to_h)
    end

    def error_fields
      records.flatten
             .select { |x| !x.error_fields.empty? }
             .collect(&:error_fields)
    end
  end
end
