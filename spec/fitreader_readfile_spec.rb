require 'fitreader'

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
end
