require 'spec_helper'

describe Wor::Paginate::Exceptions::DependencyError do
  it 'defaults to a descriptive message' do
    expect(described_class.new.message).to eq('Serializer dependency error')
  end

  it 'accepts a custom message' do
    expect(described_class.new('custom').message).to eq('custom')
  end
end
