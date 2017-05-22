require_relative 'unpack.rb'
require_relative 'fit_object.rb'
require_relative 'file_header.rb'
require_relative 'record_header.rb'
require_relative 'definition_record.rb'
require_relative 'data_field.rb'
require_relative 'data_record.rb'
require_relative 'message.rb'
require_relative 'sdk/sdk.rb'

class Fit
  attr_reader :header, :messages

  def initialize(io)
    @header = FileHeader.new(io)
    finished = []
    begin
      defs = {}
      until io.pos >= header.num_record_bytes
        h = RecordHeader.new(io)
        if h.definition?
          d = DefinitionRecord.new(io, h.local_message_type)
          finished << defs[d.local_num] if defs.key? d.local_num
          defs[d.local_num] = d
        elsif h.data?
          d = defs[h.local_message_type] if d.local_num != h.local_message_type
          d.data_records << DataRecord.new(io, d)
        else
          # TODO implement timestamps
        end
      end
      finished.push(*defs.values)
    rescue
      puts "error"
    end
    io.close
    @messages = finished.group_by(&:global_msg_num)
                        .map { |x| Message.new x }
                        .reject { |x| x.data.nil? }
  end

  def digest
    Hash[@messages.map { |x| [x.name, x.data.count] }]
  end

  def type(name)
    messages.find { |x| x.name == name }
  end
end
