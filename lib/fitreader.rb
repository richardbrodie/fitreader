require "fitreader/fitfile"

require "fitreader/version"

module Fitreader
  def self.read(path)
    FitFile.new.read(path)
  end
end
