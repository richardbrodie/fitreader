class FieldDefinition < FitObject
  attr_reader :hash

  def initialize(io)
    @hash = {}
    @hash[:field_def_num] = io.readbyte
    @hash[:size] = io.readbyte
    byte = io.readbyte
    @hash[:endianness] = read_bit(byte, 7)
    @hash[:base_num] = read_bits(byte, 4..0)
  end
end
