module Fitreader
  class FieldData
    attr_accessor :id, :raw_value, :value, :name

    def initialize(id,data,type)
      @id = id
      @raw_value = data
      process_type unless type.nil?
    end

    private
    def process_type
      ft = type[id]
      if ft != nil
        @name = ft.name
        if ft.type[0..3] == "enum"
          data = ENUMS[ft.type][data]
        elsif ft.type == :date_time
          data = process_datetime(data)
        elsif ft.type == :local_date_time
          data = process_local_datetime(data)
        elsif ft.type == :coordinates
          data = process_coord(data)
        end
        if ft.scale != 0
          if data.class == Array
            data = data.collect{|x| (x*1.0)/ft.scale}
          else
            data = (data*1.0)/ft.scale
          end
        end
        if ft.offset != 0
          if data.class == Array
            data = data.collect{|x| x - ft.offset}
          else
            data = data - ft.offset
          end
        end
        @value = data
      end
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
