module Fitreader
  class RecordHeader
    attr_accessor :header_type, :local_num,
    :timestamp_offset, :developer

    def initialize(byte)
      timstamp_header = byte & TIMESTAMP_RECORD > 0
      unless timstamp_header
        @header_type = byte & DEFINITION_MESSAGE > 0 ? :definition : :data
        @local_num = byte & NORMAL_TYPE
        # if byte & DEVELOPER_DATA == DEVELOPER_DATA
        #   @developer = true
        #   puts "developer"
        # end
        if @header_type == :definition && (byte & DEVELOPER_DATA)
          puts "DEVELOPERS!"
        end
      else
        @header_type = :timestamp
        @local_num = byte & TIMESTAMP_TYPE
        @timestamp_offset = byte & TIMESTAMP_OFFSET
        puts "timestamp header: #{@local_msg_num} :: #{@timestamp_offset}"
      end
    end

    private
    TIMESTAMP_RECORD = 128
    DEFINITION_MESSAGE = 64
    DEVELOPER_DATA = 32
    NORMAL_TYPE = 15
    TIMESTAMP_TYPE = 96
    TIMESTAMP_OFFSET = 31
  end
end
