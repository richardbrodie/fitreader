require_relative 'unpack.rb'
require_relative 'fit_object.rb'
require_relative 'file_header.rb'
require_relative 'record_header.rb'
require_relative 'definition_record.rb'
require_relative 'data_field.rb'
require_relative 'data_record.rb'
require_relative 'message.rb'
require_relative 'sdk/sdk.rb'
require 'pry'

class Fit
  attr_reader :header, :messages

  def initialize(io)
    @header = FileHeader.new(io)
    finished = []
    begin
      defs = {}
      dev_field_defs = {}
      # until (io.pos - 14) >= header.num_record_bytes
      until ((@header.num_record_bytes + 14) - io.pos) == 0
        h = RecordHeader.new(io)
        if h.definition?
          if h.has_dev_defs?
            d = DefinitionRecord.new(io, h.local_message_type, dev_field_defs)
          else
            d = DefinitionRecord.new(io, h.local_message_type)
          end
          finished << defs[d.local_num] if defs.key? d.local_num
          defs[d.local_num] = d
        elsif h.data?
          d = defs[h.local_message_type]
          data_record = DataRecord.new(io, d)
          if d.global_msg_num == 206
            dev_field = make_developer_fields(data_record.fields)
            dev_field_defs[dev_field[:dev_data_idx].raw] = dev_field
          else
            d.data_records << data_record
          end
        else
          # TODO implement timestamps
        end
      end
      finished.push(*defs.values)
      io.close
      @messages = finished.group_by(&:global_msg_num)
                          .map { |x| Message.new x }
                          .reject { |x| x.data.nil? }
    rescue => e
      binding.pry
      puts "error: #{e}\n#{e.backtrace}"
    end
  end

  def digest
    Hash[@messages.map { |x| [x.name, x.data.count] }]
  end

  def type(name)
    messages.find { |x| x.name == name }
  end

  def make_developer_fields(data_records)
    lookup = {0 => :dev_data_idx, 1 => :field_def_num, 2 => :base_type_id, 3 => :field_name, 8 => :units}
    map = {}
    data_records.each do |k,v|
      key = lookup[k]
      map[key] = v
    end
    map
  end
end
