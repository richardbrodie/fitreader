# encoding: utf-8
require 'fitreader'

describe Fitreader do
  describe 'has functioning interfaces' do
    before do
      # @path = File.join(File.dirname(__FILE__), '2016-04-09-13-19-18.fit')
      @path = File.join(File.dirname(__FILE__), '1471568492.fit')
      Fitreader.read(@path)
    end

    it 'has a valid header' do
      expect(Fitreader.header).not_to be_nil
      expect(Fitreader.header.num_records).to be(191877)
    end

    it 'has valid records' do
      expect(Fitreader.available_records).not_to be_nil
      expect(Fitreader.available_records.length).to be(14)
    end

    it 'can fetch an existing message by number' do
      expect(Fitreader.get_message_type 18).to be_a(Array)
      expect(Fitreader.get_message_type(18).first).to be_a(Fitreader::MessageType)
    end
    it 'can fetch an existing message by name' do
      expect(Fitreader.get_message_type :session).to be_a(Array)
      expect(Fitreader.get_message_type(:session).first).to be_a(Fitreader::MessageType)
    end
    it 'cannot fetch a non existing message by number' do
      expect(Fitreader.get_message_type 1234).to be(nil)
    end
    it 'cannot fetch a non existing message by name' do
      expect(Fitreader.get_message_type :non_existant).to be(nil)
    end

    it 'has the right number of records' do
      expect(Fitreader.record_values(:record).length).to be(4988)
    end

    it 'can return name-value data' do
      expect(Fitreader.record_values :session).to be_a(Array)
    end
    it 'can return error-fields' do
      expect(Fitreader.error_fields :record).to be_a(Array)
    end

    it 'can return error-messages' do
      expect(Fitreader.error_messages).to be_a(Hash)
    end

    it 'can test something' do
      # expect(Fitreader.record_values :activity).to be_a(Array)
      # expect(Fitreader.record_values :session).to be_a(Array)
    end
  end
end
