require 'fitreader/file_header'
require 'fitreader/record_header'
require 'fitreader/definition'
require 'fitreader/record'
require 'fitreader/static'

module Fitreader
  class FitFile
    attr_reader :header, :records, :defs, :file

    def initialize(path)
      @file = File.open(path, 'rb')
      @header = FileHeader.new(@file.read(14))
      if valid?
        @defs = {}
        @records = []
        while @file.pos < @header.num_records do
          process_next_record
        end
      end
    end

    private
    def valid?
      @header.valid_file
    end

    def process_next_record
      h = RecordHeader.new(@file.read(1).unpack("C").first)
      dr = @defs[h.local_msg_num]
      if h.header_type == :definition
        dr = Definition.new(h.local_msg_num, @file.read(5))
        dr.add_fields(@file.read(dr.num_fields*3))
        @defs[h.local_msg_num] = dr
      elsif h.header_type == :data
        if dr != nil
          data = @file.read(dr.content_length)
          datr = Record.new(dr, data)
          @records.push(datr)
        end
      elsif h.header_type == :timestamp
        puts "timestamp"
        # puts "msg_num: #{h.local_msg_num}, offset: #{h.timestamp_offset}"
      else
        puts "not a valid record"
      end
    end
  end
end
