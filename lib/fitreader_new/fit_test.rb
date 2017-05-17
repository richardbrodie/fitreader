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
finished = []

header = FileHeader.new(io)

begin
  until io.pos >= header.num_record_bytes
    h = RecordHeader.new(io)
    if h.definition?
      d = DefinitionRecord.new(io, h.local_message_type)
      puts "new def: #{d.global_msg_num}"
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

# puts "#{finished.map { |x| x.global_msg_num }}"
binding.pry
puts "done"
