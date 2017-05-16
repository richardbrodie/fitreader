class FileHeader < FitObject
  # FileHeaderStruct = Struct.new(
  #   :header_size,
  #   :protocol_version,
  #   :profile_version,
  #   :num_record_bytes,
  #   :valid_file,
  #   :crc
  # )

  attr_accessor :header_size, :protocol_version, :profile_version, :num_record_bytes, :valid_file, :crc

  def initialize(io)
    # @data = FileHeaderStruct.new(
    #   io.readbyte,
    #   io.readbyte,
    #   readbytes(io, 'v', 2),
    #   readbytes(io, 'V', 4),
    #   io.read(4) == '.FIT',
    #   readbytes(io, 'v', 2)
    # )
    @header_size = io.readbyte
    @protocol_version = io.readbyte
    @profile_version = readbytes(io, 'v', 2)
    @num_record_bytes = readbytes(io, 'V', 4)
    @valid_file = io.read(4) == '.FIT'
    @crc = readbytes(io, 'v', 2)
  end
end
