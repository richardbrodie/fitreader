module Fitreader
  class FieldData
    attr_accessor :id, :raw_value, :value, :name

    def initialize(data,type)
      @raw_value = @data
      @type = type
      @data = data
      process_type unless type.nil?
    end

    private
    def process_type
      ft = @type
      @name = ft[:name]
      if ft[:type][0..3] == :enum
        @data = Static.enums[ft[:type]][@data]
      elsif ft[:type] == :date_time
        @data = process_datetime
      elsif ft[:type] == :local_date_time
        @data = process_local_datetime
      elsif ft[:type] == :coordinates
        @data = process_coord
      end

      if ft[:scale] != 0
        if @data.class == Array
          @data = @data.collect{|x| (x*1.0)/ft[:scale]}
        else
          @data = (@data*1.0)/ft[:scale]
        end
      end

      if ft[:offset] != 0
        if @data.class == Array
          @data = @data.collect{|x| x - ft[:offset]}
        else
          @data = @data - ft[:offset]
        end
      end
      @value = @data
    end

    def process_local_datetime
      t = Time.new(1989, 12, 31, 0, 0, 0, '+02:00').utc.to_i
      Time.at(@data+t)
    end
    def process_datetime
      t = Time.new(1989, 12, 31, 0, 0, 0, '+00:00').utc.to_i
      Time.at(@data+t).utc
    end
    def process_coord
      @data * ( 180.0 / 2**31 )
    end
  end
end
