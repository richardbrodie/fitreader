class DataRecord < FitObject
  attr_reader :fields

  def initialize(io, definition)
    @fields = definition.hash[:field_definitions].map do |f|
      DataField.new(io, f.hash, definition.endian)
    end
  end
end
