class FieldDefinition < FitObject
  attr_reader :field_def_num, :size, :endianness, :base_num

  def initialize(io)
    @field_def_num = io.readbyte
    @size = io.readbyte
    byte = io.readbyte
    @endianness = read_bit(byte, 7)
    @base_num = read_bits(byte, 4..0)
  end
end
