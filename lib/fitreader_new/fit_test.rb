require 'pry'
require_relative 'unpack.rb'
require_relative 'fit/fit_object.rb'
require_relative 'fit/file_header.rb'
require_relative 'fit/record_header.rb'
require_relative 'fit/definition_record.rb'
require_relative 'fit/data_field.rb'
require_relative 'fit/data_record.rb'

# io = File.open('wahoo.fit', 'rb')
io = File.open('garmin.fit', 'rb')
defs = {}
final_defs = []

header = FileHeader.new(io)

begin
  until (io.pos - 16) == header.num_record_bytes
    h = RecordHeader.new(io)
    if h.definition?
      d = DefinitionRecord.new(io)
      binding.pry if d.global_msg_num == 20
      final_defs << defs[h.local_message_type]
      defs[h.local_message_type] = d
    else
      d = defs[h.local_message_type]
      d.data_records << DataRecord.new(io, d)
    end
  end
  final_defs << defs.values
rescue => e
  puts e
  puts "io: #{io.pos}"
  puts "header length: #{header.num_record_bytes}"
end

binding.pry
puts "done"
