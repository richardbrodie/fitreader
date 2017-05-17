class RecordHeader < FitObject
  attr_accessor :header_type, :message_type, :message_type_specific, :local_message_type, :time_offset

  def initialize(io)
    byte = io.readbyte

    @header_type = read_bit(byte, 7)             # 0 = normal, 1 = timestamp
    if @header_type.zero?
      @message_type = read_bit(byte, 6)          # 1 = definition, 0 = data
      @message_type_specific = read_bit(byte, 5) # 1 = developer fields
      @reserved = read_bit(byte, 4)
      @local_message_type = read_bits(byte, 3..0)
    else
      @local_message_type = read_bits(byte, 6..5)
      @time_offset = read_bits(byte, 4..0)
    end
  end

  def definition?
    @header_type.zero? && @message_type == 1
  end

  def data?
    @header_type.zero? && @message_type.zero?
  end

  def timestamp?
    @header_type == 1
  end
end
