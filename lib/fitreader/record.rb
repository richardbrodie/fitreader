require 'fitreader/field_data'

module Fitreader
  class Record
    attr_reader :local_msg_num, :global_msg_num, :name, :fields
    def initialize(definition, bytes)
      @local_msg_num = definition.local_msg_num
      @global_msg_num = definition.global_msg_num
      @name = definition.name
      @fields = {}
      @msg_type = Static.message[@global_msg_num]

      # if ENV["RAILS_ENV"] != 'test' && @global_msg_num == 23
      #   binding.pry
      # end
      unless @msg_type.nil?
        start = 0
        definition.fields.each do |f|
          raw = bytes[start...start+=f.size]
          b = Static.base[f.base_type_num]
          data = unpack_data(f, b, raw)
          process_data(f, b[:invalid], data)
        end
      else
        puts "no known message type: #{@global_msg_num}"
      end

      if @global_msg_num == 21
        process_event
      elsif @global_msg_num == 23
        process_deviceinfo
      end
    end

    def unpack_data(f, b, raw)
      if !b[:unpack_type].nil?
        if b[:size] != f.size && f.base_type_num != 7
          data = []
          s = 0
          (f.size/b[:size]).times do |_|
            data.push(raw[s..s+=b[:size]].unpack(b[:unpack_type]).first)
          end
        else
          data = raw.unpack(b[:unpack_type]).first
        end
      elsif f.base_type_num.zero?
        data = raw.unpack('C').first
      else
        data = raw.split(/\0/)[0]
      end
    end

    def process_data(f, invalid, data)
      field_def = @msg_type[f.def_num]

      unless field_def.nil?
        if data.class != Array
          @fields[f.def_num] = FieldData.new(f.def_num, data, field_def) unless data == invalid
        elsif data.class == Array
          data = data.select{ |x| x != invalid }
          @fields[f.def_num] = FieldData.new(f.def_num, data, field_def) unless data.empty?
        else
          puts "data class unknown: #{@global_msg_num}"
        end
      else
        puts "message type: #{@name} (#{@global_msg_num}) has no known field type: #{f.def_num}" if field_def.nil?
      end
    end

    def temporal?
      fields.key?(253)
    end

    def get_val(key)
      if key.class == String
        f = @fields.values.detect{|v| v.name == key}
      elsif key.class == Integer
        f = @fields[key]
      end
      return f != nil ? f.value : nil
    end

    def get_raw(key)
      if key.class == String
        f = @fields.values.detect{|v| v.name == key}
      elsif key.class == Integer
        f = @fields[key]
      end
      return !f.nil? ? f.raw_value : nil
    end

    def to_s
      s = "#{name} (#{global_msg_num})\n"
      @fields.each do |_, v|
        s += v.to_s
      end
      "#{s}\n"
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
      if !d.nil? && !t.nil?
        d.value = case t.value
                  when :antplus
                    Static.enums[:antplus_device_type][d.raw_value]
                  end
      end
      d = @fields[4]
      t = @fields[2]
      if !d.nil? && !t.nil?
        d.value = case t.value
                  when :garmin, :dynastream, :dynastream_oem
                    Static.enums[:enum_garmin_product][d.raw_value]
                  end
      end
    end

    def process_gear_change(data)
      [data].pack('V*').unpack('C*')
    end
  end
end
