require_relative 'field_definition.rb'

class DefinitionRecord < FitObject
  attr_reader :hash

  def initialize(io)
    @hash = {}
    @hash[:reserved] = io.readbyte
    @hash[:architecture] = io.readbyte
    char = @hash[:architecture].zero? ? 'v' : 'n'
    @hash[:global_msg_num] = readbytes(io, char, 2)
    @hash[:num_fields] = io.readbyte
    @hash[:field_definitions] = Array.new(num_fields) { FieldDefinition.new(io) }
  end

  def num_fields
    @hash[:num_fields]
  end

  def endian
    if @hash[:architecture].zero?
      :little
    else
      :big
    end
  end
end
