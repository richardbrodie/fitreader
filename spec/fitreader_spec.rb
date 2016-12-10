require 'pry'
require 'fitreader'

describe Fitreader::Static do
  it "const is loaded" do
    expect(Fitreader::Static.const.class).to eql(Hash)
  end

  it "const has data" do
    expect(Fitreader::Static.const['enum_file'][1]).to eql('device')
  end
end

describe Fitreader::FitFile do
  before do
    @path = File.join( File.dirname(__FILE__),'2016-04-09-13-19-18.fit')
  end
  
  it "test file exists" do
    expect(File.exist?(@path)).to eql(true)
  end

  it "broccoli is gross" do
    expect(Fitreader::FitFile.new(@path)).to eql("Gross!")
  end
end
