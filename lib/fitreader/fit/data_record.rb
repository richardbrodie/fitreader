class DataRecord < FitObject
  attr_reader :fields

  def initialize(io, definition)
    @fields = Hash[definition.field_definitions.map do |f|
      [f.field_def_num, DataField.new(io, f, definition.endian)]
    end]
  end

  def valid
    @fields.select { |_, v| v.valid }
  end

  def second_level(nums)
    valid.select { |k, _| nums.include? k }
  end
end
