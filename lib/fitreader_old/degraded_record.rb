require 'fitreader/field_data'
require 'fitreader/errors'

module Fitreader
  class DegradedRecord
    attr_reader :fields
    def initialize(definition, bytes)
      @endian = definition.endian
      @fields = {}

      start = 0
      definition.field_definitions.each do |f|
        raw = bytes[start...start+=f.size]
        b = Static.base[f.base_num]
        data = unpack_data(f, b, raw)
        @fields[f.def_num] = data
      end
    end

    def unpack_data(f, b, raw)
      if !b[:unpack_type].nil?
        unpack = b[:endian] == 1 ? b[:unpack_type][@endian] : b[:unpack_type]
        if b[:size] != f.size && f.base_num != 7
          data = []
          s = 0
          (f.size/b[:size]).times do |_|
            data.push(raw[s..s+=b[:size]].unpack(unpack).first)
          end
        else
          data = raw.unpack(unpack).first
        end
      elsif f.base_num.zero?
        data = raw.unpack('C').first
      else
        data = raw.split(/\0/)[0]
      end
    end
  end
end
