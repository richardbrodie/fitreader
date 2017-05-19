require 'pry'
require_relative 'fitreader/unpack.rb'
require_relative 'fitreader/fit/fit_object.rb'
require_relative 'fitreader/fit/file_header.rb'
require_relative 'fitreader/fit/record_header.rb'
require_relative 'fitreader/fit/definition_record.rb'
require_relative 'fitreader/fit/data_field.rb'
require_relative 'fitreader/fit/data_record.rb'
require_relative 'fitreader/fit/message.rb'
require_relative 'fitreader/fit/sdk/sdk.rb'

# io = File.open('wahoo.fit', 'rb')
# io = File.open('fitreader/garmin.fit', 'rb')
io = File.open('fitreader/1740015980.fit', 'rb')
defs = {}
finished = []

header = FileHeader.new(io)

begin
  until io.pos >= header.num_record_bytes
    h = RecordHeader.new(io)
    if h.definition?
      d = DefinitionRecord.new(io, h.local_message_type)
      finished << defs[d.local_num] if defs.key? d.local_num
      defs[d.local_num] = d
    elsif h.data?
      d = defs[h.local_message_type] if d.local_num != h.local_message_type
      d.data_records << DataRecord.new(io, d)
    else # timestamp
      puts 'timestamp!'
    end
  end
  finished.push(*defs.values)
  # finished.each(&:process)
rescue => e
  puts e
end

d = finished.first.first_level
m = Message.new finished[3]

binding.pry
puts "done"
