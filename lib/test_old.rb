require 'pry'
require File.join( File.dirname(__FILE__), 'fitreader_old/fitfile')

# io = File.open('fitreader/garmin.fit', 'rb')
io = File.open('fitreader/1740015980.fit', 'rb')
f = Fitreader::FitFile.new(io)

binding.pry
puts "done"
