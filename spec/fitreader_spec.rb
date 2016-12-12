# encoding: utf-8
require 'fitreader'

describe Fitreader::Static do
  it 'const is loaded' do
    expect(Fitreader::Static.enums.class).to eql(Hash)
  end

  it 'const has data' do
    expect(Fitreader::Static.enums[:enum_file][1]).to eql(:device)
  end
end

describe Fitreader do
  before do
    @path = File.join(File.dirname(__FILE__), '2016-04-09-13-19-18.fit')
  end

  it 'test file exists' do
    expect(File.exist?(@path)).to eql(true)
  end

  it 'parses file without exceptions' do
    expect { Fitreader.read(@path) }.not_to raise_error
  end
end
