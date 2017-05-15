require_relative "lib/fitreader.rb"

io = File.open('garmin.fit', 'rb')
Fitreader.read io
