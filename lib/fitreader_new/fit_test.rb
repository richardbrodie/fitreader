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

puts FileHeader.new(io).hash
RecordHeader.new(io)
d = DefinitionRecord.new(io)
RecordHeader.new(io)
dr = DataRecord.new(io, d)

binding.pry
puts "done"
