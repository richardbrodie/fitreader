module Fitreader
  class FieldDefinition
    attr_accessor :def_num, :size, :base_type_num, :base_type

    def initialize(msg_num, bytes)
      @def_num = bytes[0].unpack('C').first
      @size = bytes[1].unpack('C').first
      # @single_byte = bytes[2].unpack('C').first & ENDIAN_ABILITY == 0
      @base_type_num = bytes[2].unpack('C').first & BASE_TYPE_NUM
    end

    def unpack?
      return @base_type.unpack?
    end

    def to_s
      "def_num: #{def_num}, base_type: #{base_type_num}, size: #{size}"
    end

    private
    ENDIAN_ABILITY = 128
    BASE_TYPE_NUM = 31
  end
end
