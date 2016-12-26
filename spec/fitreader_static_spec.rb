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
