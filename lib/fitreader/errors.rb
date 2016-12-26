module Fitreader
  class UnknownFieldTypeError < RuntimeError
    attr :field, :definition, :data, :reason
    def initialize(definition, field, data, reason)
      @field = field
      @definition = definition
      @data = data
      @reason = reason
    end
  end

  class UnknownMessageTypeError < RuntimeError
    # attr :definition
    # def initialize(definition)
    #   @definition = definition
    # end
  end
end
