class DataRecord < FitObject
  attr_reader :fields, :global_num

  def initialize(io, definition)
    @global_num = definition.global_msg_num
    @fields = Hash[definition.field_definitions.map do |f|
      [f.field_def_num, DataField.new(io, f, definition.endian)]
    end]
  end

  def valid
    @fields.select { |_, v| v.valid }
  end
end
