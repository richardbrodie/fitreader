require_relative 'field_definition.rb'

class DefinitionRecord < FitObject
  attr_reader :reserved, :architecture, :global_msg_num, :num_fields, :field_definitions, :data_records, :local_num

  def initialize(io, local_num)
    @local_num = local_num
    @reserved = io.readbyte
    @architecture = io.readbyte
    char = @architecture.zero? ? 'v' : 'n'
    @global_msg_num = readbytes(io, char, 2)
    @num_fields = io.readbyte
    @field_definitions = Array.new(num_fields) { FieldDefinition.new(io) }
    @data_records = []
  end

  def endian
    @architecture.zero? ? :little : :big
  end

  def first_level
    fd = Sdk.fields(@global_msg_num)
    return if fd.nil?
    @data_records.map do |d|
      Hash[d.second_level(fd.keys).map { |k, v| [k, [fd[k][:name], v.raw]] }]
    end
  end
end
