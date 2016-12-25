require 'pry'
require 'fitreader/fitfile'
require 'fitreader/version'
require 'fitreader/static'

module Fitreader
  def self.read(path)
    @f = FitFile.new(path)
  end

  def self.header
    @f.header
  end

  def self.available_records
    @f.records.collect { |x| [x.definition.global_num, x.definition.name] }
      .group_by { |i| i }
      .sort
      .collect { |k, v| k << v.length }
  end

  def self.filter_by_record(filter)
    if filter.is_a?(Symbol)
      @f.records.select { |x| x.definition.name == filter }
    elsif filter.is_a?(Integer)
      @f.records.select { |x| x.definition.global_num == filter }
    else
      raise ArgumentError, "needs a string or a symbol"
    end
  end

  def self.record_values(filter)
    records = filter_by_record filter
    records.collect {|x| x.fields.values.collect{|z| [z.name, z.value]}}.collect{|y| y.to_h}
  end

  # def self.error_fields(filter=nil)
  #   @f.records.
  # end

  # def self.filter_by_scope(filter)
  #   valid = Static.scope.include? filter
  #   unless valid
  #     @f.records.select { |x| x.type == filter }
  #   else
  #     puts "invalid scope, must be one of #{Static.scope}"
  #   end
  # end
end
