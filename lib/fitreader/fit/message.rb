class Message
  attr_accessor :global_num, :name, :data

  def initialize(definition)
    @global_num = definition.global_msg_num
    @name = Sdk.message(@global_num)
    @data = definition.first_level
  end
end
