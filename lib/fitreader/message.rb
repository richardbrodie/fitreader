class Message
  attr_accessor :global_num, :name, :data

  def initialize(definitions)
    @global_num = definitions[0]
    @name = Sdk.message(@global_num)
    return unless @name

    fd = Sdk.fields(@global_num)
    @data = definitions[1].map { |x| make_message(x, fd) }.flatten
  end

  private

  def make_message(definition, fields)
    return if definition.valid.nil?
    definition.valid.map do |d|
      h = Hash[d.map { |k, v| process_value(fields[k], v.raw) }]
      case @global_num
      when 21
        h = process_event(h)
      when 0, 23
        h = process_deviceinfo(h)
      end
      h
    end
  end

  def process_value(type, val)
    if type[:type][0..3].to_sym == :enum
      val = Sdk.enum(type[:type])[val]
    elsif type[:type] == :date_time
      t = Time.new(1989, 12, 31, 0, 0, 0, '+00:00').utc.to_i
      Time.at(val + t).utc
    elsif type[:type] == :local_date_time
      t = Time.new(1989, 12, 31, 0, 0, 0, '+02:00').utc.to_i
      val = Time.at(val + t)
    elsif type[:type] == :coordinates
      val *= (180.0 / 2**31)
    end

    unless type[:scale].zero?
      if val.is_a? Array
        val = val.map { |x| (x * 1.0) / type[:scale] }
      else
        val = (val * 1.0) / type[:scale]
      end
    end

    unless type[:offset].zero?
      if val.is_a? Array
        val.map { |x| x - type[:offset] }
      else
        val - type[:offset]
      end
    end
    [type[:name], val]
  rescue => e
    puts e
  end

  def process_event(h)
    case h[:event]
    when :rear_gear_change, :front_gear_change
      h[:data] = h[:data].pack('V*').unpack('C*')
    end
    h
  end

  def process_deviceinfo(h)
    case h[:source_type]
    when :antplus
      h[:device_type] = Sdk.enum(:antplus_device_type)[h[:value]]
    end

    case h[:manufacturer]
    when :garmin, :dynastream, :dynastream_oem
      h[:garmin_product] = Sdk.enum(:enum_garmin_product)[h[:garmin_product]]
    end
    h
  end
end
