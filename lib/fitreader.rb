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
      .select { |_,v| !v.any? { |z| z.definition.name.nil? } }
      .select { |_,v| !v.any? { |z| z.records.length.zero? } }
      .collect { |x| [x[0], x[1].first.definition.name, x[1].collect(&:records).flatten.length] }
      .sort
  end

  def self.get_message_type(filter)
    if filter.is_a?(Symbol)
      res = @f.messages.find { |_,y| y.any? { |z| z.definition.name == filter } }
      res[1] unless res.nil?
    elsif filter.is_a?(Integer)
      @f.messages[filter]
    else
      raise ArgumentError, 'needs a string or a symbol'
    end
  end

  def self.record_values(filter)
    message = get_message_type filter
    message.collect(&:record_values).flatten
  end

  def self.error_messages
    @f.messages.select { |_, v| !v.any? { |x| x.undefined_records.empty? } }
  end

  def self.error_fields(filter)
    message = get_message_type filter
    message.collect(&:error_fields).flatten
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
