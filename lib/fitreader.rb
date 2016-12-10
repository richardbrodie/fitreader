require "fitreader/fitfile"
require "fitreader/version"
require "fitreader/static"

module Fitreader
  def self.read(path)
    @f = FitFile.new
    @f.read(path)
  end

  def self.header
    @f.header
  end

  def self.available_records
    binding.pry
    @f.records.collect{|x| [x.global_msg_num, x.name]}.uniq.to_h
  end

  def self.records_by_type(type)
    @f.records.select{|x| x.name == type}
  end

  def self.records_by_msgnum(num)
    @f.records.select{|x| x.global_msg_num == num}
  end
end
