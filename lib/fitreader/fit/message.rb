class Message
  attr_accessor :global_num, :name, :records

  def initialize(definitions)
    # @global_num = definitions.first.global_msg_num
    # @name = FitSdk.message_name(@global_num)
    definitions.each do |d|

    end
  end
end
