module Unpack
  def readbytes(io, char, len)
    io.read(len).unpack(char).first
  end

  def read_multiple(io, char, len, size)
    if char == 'Z*'
      readbytes(io, char, len)
    else
      multiples = len / size
      res = io.read(len).unpack(char * multiples)
      if res.length == 1
        res.first
      else
        res
      end
    end
  end

  def read_bit(byte, bit)
    (byte & MASKS[bit]) >> bit
  end

  def read_bits(byte, range)
    mask = range.first
                .downto(range.last)
                .inject(0) { |sum, i| sum + MASKS[i] }
    (byte & mask) >> range.last
  end

  MASKS = {
    7 => 0b10000000,
    6 => 0b01000000,
    5 => 0b00100000,
    4 => 0b00010000,
    3 => 0b00001000,
    2 => 0b00000100,
    1 => 0b00000010,
    0 => 0b00000001
  }.freeze
end
