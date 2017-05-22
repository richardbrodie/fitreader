require 'ostruct'
class FitObject
  include Unpack

  def to_h
    @data.to_h
  end
end
