require 'fitreader/field_definition'
require 'fitreader/constants'

module Fitreader
  class Definition
    attr_accessor :global_msg_num, :num_fields, :fields, :local_msg_num, :name
    def initialize(msg_num, bytes)
      @local_msg_num = msg_num
      @architecture = bytes[1].unpack('C').first
      @global_msg_num = bytes[2..3].unpack('v').first
      @name = ENUMS[:enum_mesg_num][@global_msg_num]
      @num_fields = bytes[4].unpack('C').first
      @fields = []
    end

    def add_fields(bytes)
      bytes.chars.each_slice(3) do |x|
        fd = FieldDefinition.new(@global_msg_num, x)
        @fields.push(fd)
      end
    end

    def content_length
      @fields.inject(0){|sum,x| sum + x.size}
    end

    def message_type
      MESSAGE_TYPE[@global_msg_num]
    end
  end
end
