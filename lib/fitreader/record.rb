require 'fitreader/field_data'

module Fitreader
  class Record
    attr_accessor :local_msg_num, :global_msg_num, :name, :fields
    def initialize(definition, bytes)
      @local_msg_num = definition.local_msg_num
      @global_msg_num = definition.global_msg_num
      @name = definition.name
      @fields = {}
      start = 0
      msg_type = MESSAGE_FIELDS[@global_msg_num]
      # if ENV["RAILS_ENV"] != 'test' && @global_msg_num == 23
      #   binding.pry
      # end
      definition.fields.each do |f|
        raw = bytes[start...start+=f.size]
        base_type = BASE_TYPES[f.base_type_num]

        if base_type.unpack?
          if base_type.size != f.size and base_type.id != 7
            data = []
            s = 0
            (f.size/base_type.size).times do |x|
              data.push(raw[s..s+=base_type.size].unpack(base_type.unpack_type).first)
            end
          else
            data = raw.unpack(base_type.unpack_type).first
          end
        elsif base_type.id == 0
          data = raw.unpack('C').first
        else
          data = raw.split(/\0/)[0]
        end

        if data.class != Array
          @fields[f.def_num] = FieldData.new(f.def_num, data, msg_type) unless data == base_type.invalid
        elsif data.class == Array
          data = data.select{|x| x != base_type.invalid}
          @fields[f.def_num] = FieldData.new(f.def_num, data, msg_type) unless data.empty?
        end
      end

      if @global_msg_num == 21
        process_event
      elsif @global_msg_num == 23
        process_deviceinfo
      end
    end

    def temporal?
      fields.has_key?(253)
    end

    def msg_type
      puts "#{name} (#{global_msg_num})"
    end

    def get_val(key)
      if key.class == String
        f = @fields.values.detect{|v| v.name == key}
      elsif key.class == Fixnum
        f = @fields[key]
      end
      return f != nil ? f.value : nil
    end

    def get_raw(key)
      if key.class == String
        f = @fields.values.detect{|v| v.name == key}
      elsif key.class == Fixnum
        f = @fields[key]
      end
      return f != nil ? f.raw_value : nil
    end

    def to_s
      s = "#{name} (#{global_msg_num})\n"
      @fields.each do |k,v|
        s += v.to_s
      end
      return s+"\n"
    end

    private
    def process_event
      t = @fields[0]
      d = @fields[3]
      d.value = case t.value
      when :rear_gear_change, :front_gear_change
        process_gear_change(d.raw_value)
      end
    end

    def process_deviceinfo
      d = @fields[1]
      t = @fields[25]
      if d != nil && t != nil
        d.value = case t.value
        when :antplus
          ENUMS[:antplus_device_type][d.raw_value]
        end
      end
      d = @fields[4]
      t = @fields[2]
      if d != nil && t != nil
        d.value = case t.value
        when :garmin, :dynastream, :dynastream_oem
          ENUMS[:enum_garmin_product][d.raw_value]
        end
      end
    end

    def process_gear_change(data)
      [data].pack('V*').unpack('C*')
    end
  end
end
