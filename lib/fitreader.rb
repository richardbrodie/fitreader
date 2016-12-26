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
    @f.messages
      .select { |x,y| !y.definition.name.nil? }
      .select { |x,y| !y.records.length.zero? }
      .collect { |x| [x[0], x[1].definition.name, x[1].records.length] }
      .sort
  end

  def self.get_message_type(filter)
    if filter.is_a?(Symbol)
      res = @f.messages.find { |_,y| y.definition.name == filter}
      res[1] unless res.nil?
    elsif filter.is_a?(Integer)
      @f.messages[filter]
    else
      raise ArgumentError, "needs a string or a symbol"
    end
  end

  def self.record_values(filter)
    message = get_message_type filter
    message.records.collect {|x| x.fields.values.collect{|z| [z.name, z.value]}}.collect{|y| y.to_h}
  end

  def self.error_messages
    @f.messages.select { |_,v| !v.undefined_records.empty? }
  end

  def self.error_fields(filter)
    message = get_message_type filter
    message.records.select{|x| !x.error_fields.empty?}.collect{|y| y.error_fields}
  end

  # def self.filter_by_scope(filter)
  #   valid = Static.scope.include? filter
  #   unless valid
  #     @f.records.select { |x| x.type == filter }
  #   else
  #     puts "invalid scope, must be one of #{Static.scope}"
  #   end
  # end
end
