require 'fitreader/field_definition'

module Fitreader
  class Definition
    attr_accessor :name, :global_num, :local_num, :fit_msg, :field_definitions, :num_fields
    def initialize(msg_num, bytes)
      @local_num = msg_num
      @architecture = bytes[1].unpack('C').first
      @global_num = bytes[2..3].unpack('v').first
      @fit_msg = Static.message[@global_num]
      @name = Static.enums[:enum_mesg_num][@global_num]
      @num_fields = bytes[4].unpack('C').first
    end

    def field(id)
      @field_definitions.find { |x| x.def_num == id }
    end

    def add_fields(bytes)
      bytes.chars.each_slice(3) do |x|
        fd = FieldDefinition.new(@global_num, x)
        (@field_definitions ||= []).push(fd)
      end
    end

    def content_length
      @field_definitions.inject(0){|sum,x| sum + x.size}
    end

    def message_type
      Static.message[@global_num]
    end
  end
end
