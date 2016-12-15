# encoding: utf-8
require 'fitreader'

describe Fitreader::Static do
  it 'const is loaded' do
    expect(Fitreader::Static.enums.class).to eql(Hash)
  end

  it 'const has data' do
    expect(Fitreader::Static.enums[:enum_file][1]).to eql(:device)
  end

  it 'scope is readable' do
    expect(Fitreader::Static.scope).to include(:ride)
    expect(Fitreader::Static.scope).not_to include(:bike)
  end
end

describe Fitreader do
  describe 'read fit file' do
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

  describe 'has functioning interfaces' do
    before do
      @path = File.join(File.dirname(__FILE__), '2016-04-09-13-19-18.fit')
      Fitreader.read(@path)
    end

    it 'has a valid header' do
      expect(Fitreader.header).not_to be_nil
      expect(Fitreader.header.num_records).to be(89139)
    end

    it 'has valid records' do
      expect(Fitreader.available_records).not_to be_nil
      expect(Fitreader.available_records.length).to be(14)
    end
  end
end
