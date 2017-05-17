require 'yaml'

class Sdk
  @enums ||= YAML.load_file('enums.yml')
  @fields ||= YAML.load_file('fields.yml')
  @messages ||= YAML.load_file('messages.yml')

  def self.enum(name)
    @enums[name]
  end

  def self.field(msg, field)
    @fields[msg][field]
  end

  def self.fields(msg)
    @fields[msg]
  end

  def self.message(num)
    @messages[num]
  end
end
