module Fitreader
  class FieldData
    attr_accessor :id, :raw_value, :value, :name

    def initialize(id, raw_value, type)
      @id = id
      @raw_value = raw_value
      process_type(raw_value, type) unless type.nil?
    end

    private
    def process_type(data, type)
      @name = type[:name]
      if type[:type][0..3] == :enum
        data = Static.enums[type[:type]][data]
      elsif type[:type] == :date_time
        data = process_datetime(data)
      elsif type[:type] == :local_date_time
        data = process_local_datetime(data)
      elsif type[:type] == :coordinates
        data = process_coord(data)
      end

      if type[:scale] != 0
        if data.class == Array
          data = data.collect{|x| (x*1.0)/type[:scale]}
        else
          data = (data*1.0)/type[:scale]
        end
      end

      if type[:offset] != 0
        if data.class == Array
          data = data.collect{|x| x - type[:offset]}
        else
          data = data - type[:offset]
        end
      end
      @value = data
    end

    def process_local_datetime(data)
      t = Time.new(1989, 12, 31, 0, 0, 0, '+02:00').utc.to_i
      Time.at(data+t)
    end
    def process_datetime(data)
      t = Time.new(1989, 12, 31, 0, 0, 0, '+00:00').utc.to_i
      Time.at(data+t).utc
    end
    def process_coord(data)
      data * ( 180.0 / 2**31 )
    end
  end
end
