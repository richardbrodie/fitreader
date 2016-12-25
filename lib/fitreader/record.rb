require 'fitreader/field_data'
require 'fitreader/errors'

module Fitreader
  class Record
    attr_reader :definition, :fields, :error_fields
    def initialize(definition, bytes)
      @definition = definition
      @fields = {}
      @error_fields = {}

      unless @definition.fit_msg.nil?
        start = 0
        @definition.field_definitions.each do |f|
          raw = bytes[start...start+=f.size]
          b = Static.base[f.base_num]
          data = unpack_data(f, b, raw)
          begin
            process_data(f.def_num, b[:invalid], data)
          rescue UnknownFieldTypeError => error
            push_error error.reason, error.field, error.data
            # puts error unless error.reason == :invalid
          end
        end

        if @definition.global_num == 21
          process_event
        elsif @definition.global_num == 23
          process_deviceinfo
        end
      else
        msg = "no known message type: #{@definition.global_num}"
        raise UnknownMessageTypeError.new(definition), msg, caller
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

    def process_data(fieldDefNum, invalid, data)
      field_def = @definition.fit_msg[fieldDefNum]
      unless field_def.nil?
        # populate invalid
        if data.is_a?(Array)
          data = data.select{ |x| x != invalid } if data.is_a?(Array)
          invalid = data.empty?
        else
          invalid = data == invalid
        end

        unless invalid
          @fields[fieldDefNum] = FieldData.new(fieldDefNum, data, field_def)
        else
          msg = "invalid field data (#{data}) processed for field number [#{fieldDefNum}::#{field_def[:name]}] in message (#{@definition.global_num}::#{@definition.name})"
          raise UnknownFieldTypeError.new(@definition, fieldDefNum, data, :invalid), msg, caller
        end
      else
        msg = "invalid field [#{fieldDefNum}] encountered for message [#{@definition.global_num}::#{@definition.name}] with data [#{data}]"
        raise UnknownFieldTypeError.new(@definition, fieldDefNum, data, :unknown), msg, caller
      end
    end

    def temporal?
      fields.key?(253)
    end

    def push_error(reason, field, data)
      (@error_fields[reason] ||= {})[field] = data
    end

    # :file_id 1
    # :user_profile 1
    # :zones_target 1
    # :session 1
    # :lap 1
    # :record 2899
    # :event 73
    # :source 58
    # :device_info 14
    # :activity 1
    # :file_creator 1
    # :training_file 1
    # :battery_info 40
    # :sensor_info 3
    def type
      case @definition.name
      when :file_id, :user_profile, :zones_target, :session
        :ride
      when condition
        :lap
      else
        :time
      end
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
      s = "#{name} (#{definition.global_num})\n"
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
