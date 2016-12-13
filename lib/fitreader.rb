require 'pry'
require 'fitreader/fitfile'
require 'fitreader/version'
require 'fitreader/static'

module Fitreader
  def self.read(path)
    @f = FitFile.new(path)
    binding.pry
  end

  def self.header
    @f.header
  end

  def self.available_records
    @f.records.collect { |x| [x.global_msg_num, x.name] }
      .group_by { |i| i }
      .sort
      .map { |k, v| { k => v.length } }
  end

  def self.filter_records(filter)
    if filter.is_a?(Symbol)
      @f.records.select { |x| x.name == filter }
    elsif filter.is_a?(Integer)
      @f.records.select { |x| x.global_msg_num == filter }
    else
      throw
    end
  end
end
