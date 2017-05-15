class FileHeader < FitObject
  attr_reader :hash

  def initialize(io)
    @hash = {}
    @hash[:header_size] = io.readbyte
    @hash[:protocol_version] = io.readbyte
    @hash[:profile_version] = readbytes(io, 'v', 2)
    @hash[:num_records] = readbytes(io, 'V', 4)
    @hash[:valid_file] = io.read(4) == '.FIT'
    @hash[:crc] = readbytes(io, 'v', 2)
  end
end
