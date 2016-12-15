require 'fitreader/field_data'
require 'fitreader/errors'

module Fitreader
  class DegradedRecord
    attr_reader :definition, :fields
    def initialize(definition, bytes)
      @definition = definition
      @fields = {}

      start = 0
      @definition.field_definitions.each do |f|
        raw = bytes[start...start+=f.size]
        b = Static.base[f.base_num]
        data = unpack_data(f, b, raw)
        @fields[f.def_num] = data
      end
    end

    def unpack_data(f, b, raw)
      if !b[:unpack_type].nil?
        if b[:size] != f.size && f.base_num != 7
          data = []
          s = 0
          (f.size/b[:size]).times do |_|
            data.push(raw[s..s+=b[:size]].unpack(b[:unpack_type]).first)
          end
        else
          data = raw.unpack(b[:unpack_type]).first
        end
      elsif f.base_num.zero?
        data = raw.unpack('C').first
      else
        data = raw.split(/\0/)[0]
      end
    end
  end
end
