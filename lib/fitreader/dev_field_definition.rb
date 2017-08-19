class DevFieldDefinition < FitObject
  attr_reader :field_num, :size, :developer_data_index, :field_def

  def initialize(io, field_defs)
    @field_num = io.readbyte
    @size = io.readbyte
    @developer_data_index = io.readbyte
    @field_def = field_defs[@developer_data_index]
  end
end
