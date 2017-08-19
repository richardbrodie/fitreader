require_relative 'field_definition.rb'
require_relative 'dev_field_definition.rb'

class DefinitionRecord < FitObject
  attr_reader :reserved, :global_msg_num, :num_fields, :field_definitions, :data_records, :local_num, :dev_defs

  def initialize(io, local_num, dev_field_defs = nil)
    @local_num = local_num

    # read record
    @reserved = io.readbyte
    @architecture = io.readbyte
    char = @architecture.zero? ? 'v' : 'n'
    @global_msg_num = readbytes(io, char, 2)
    num_fields = io.readbyte

    # read fields
    @field_definitions = Array.new(num_fields) { FieldDefinition.new(io) }

    unless dev_field_defs.nil?
      num_fields = io.readbyte
      @dev_defs = Array.new(num_fields) { DevFieldDefinition.new(io, dev_field_defs) }
    end
    @data_records = []
  end

  def endian
    @architecture.zero? ? :little : :big
  end

  def valid
    fd = Sdk.fields(@global_msg_num)
    return if fd.nil?
    @data_records.map do |d|
      d.valid.select { |k, _| fd.keys.include? k }.merge(d.dev_fields)
    end
  end
end
