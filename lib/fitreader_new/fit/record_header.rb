class RecordHeader < FitObject
  attr_reader :hash

  def initialize(io)
    byte = io.readbyte
    @hash = {}
    @hash[:header_type] = read_bit(byte, 7)
    if @hash[:header_type].zero?
      @hash[:message_type] = read_bit(byte, 6)
      @hash[:message_type_specific] = read_bit(byte, 5)
      @hash[:reserved] = read_bit(byte, 4)
      @hash[:local_message_type] = read_bits(byte, 3..0)
    else
      @hash[:local_message_type] = read_bits(byte, 6..5)
      @hash[:time_offset] = read_bits(byte, 4..0)
    end
  end

  def definition?
    @hash[:header_type].zero? && @hash[:message_type] == 1
  end

  def timestamp?
    @hash[:header_type] == 1
  end
end
