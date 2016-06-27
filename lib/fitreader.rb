require "fitreader/fitfile"
require 'pry'
require "fitreader/version"

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

  def self.records(type = nil)
    if type.nil?
      @f.records
    else
      @f.records.select{|x| x.name == type}
    end
  end
end
