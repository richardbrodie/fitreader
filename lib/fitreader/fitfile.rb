require 'fitreader/file_header'
require 'fitreader/record_header'
require 'fitreader/definition'
require 'fitreader/record'
require 'fitreader/degraded_record'
require 'fitreader/static'

module Fitreader
  class FitFile
    attr_reader :header, :records, :defs, :file, :error_records

    def initialize(path)
      @file = File.open(path, 'rb')
      @header = FileHeader.new(@file.read(14))
      if valid?
        @defs = {}
        @records = []
        @error_records = []
        while @file.pos < @header.num_records do
          process_next_record
        end
        puts "number of bad records found: #{@error_records.length}"
      end
    end

    private
    def valid?
      @header.valid_file
    end

    def process_next_record
      h = RecordHeader.new(@file.read(1).unpack("C").first)
      dr = @defs[h.local_num]
      if h.header_type == :definition
        dr = Definition.new(h.local_num, @file.read(5))
        dr.add_fields(@file.read(dr.num_fields*3))
        @defs[h.local_num] = dr
      elsif h.header_type == :data
        unless dr.nil?
          begin
            data = @file.read(dr.content_length)
            datr = Record.new(dr, data)
            @records.push(datr)
          rescue UnknownMessageTypeError => error
            # @error_records.push(error.definition)
            puts error
            degraded = DegradedRecord.new(dr, data)
            @error_records.push degraded
          end
        else
          msg = "no record def found! #{h.local_msg_num}"
          raise msg
        end
      elsif h.header_type == :timestamp
        raise "timestamp :: msg_num: #{h.local_msg_num}, offset: #{h.timestamp_offset}"
      else
        raise "not a valid record"
      end
    end
  end
end
