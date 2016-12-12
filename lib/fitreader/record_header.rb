module Fitreader
  class RecordHeader
    attr_accessor :header_type, :local_msg_num,
    :timestamp_offset, :developer

    def initialize(byte)
      timstamp_header = byte & TIMESTAMP_RECORD > 0
      if not timstamp_header
        @header_type = byte & DEFINITION_MESSAGE > 0 ? :definition : :data
        @local_msg_num = byte & NORMAL_TYPE
        if byte & DEVELOPER_DATA == DEVELOPER_DATA
          @developer = true
          puts "developer"
        end
      else
        @header_type = :timestamp
        @local_msg_num = byte & TIMESTAMP_TYPE
        @timestamp_offset = byte & TIMESTAMP_OFFSET
        puts "timestamp header: #{@local_msg_num} :: #{@timestamp_offset}"
      end
    end

    private
    TIMESTAMP_RECORD = 0b10000000
    DEFINITION_MESSAGE = 0b01000000
    DEVELOPER_DATA = 0b00100000
    NORMAL_TYPE = 0b00001111
    TIMESTAMP_TYPE = 0b01100000
    TIMESTAMP_OFFSET = 0b00011111
  end
end
