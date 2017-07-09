require 'pry'
require_relative '../lib/fitreader/fit'

# f = File.open("../spec/2016-04-09-13-19-18.fit", "r")
f = File.open("../spec/1471568492.fit", "r")
fit = Fit.new f
