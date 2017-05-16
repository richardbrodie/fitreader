require 'ostruct'
class FitObject
  include Unpack

  # def method_missing(m)
  #   if @data.respond_to?(m)
  #     @data.send(m)
  #   else
  #     super(m)
  #   end
  # end
  #
  # def respond_to?(method, include_private = false)
  #   super || @data.respond_to?(method, include_private)
  # end

  def to_h
    @data.to_h
  end
end
