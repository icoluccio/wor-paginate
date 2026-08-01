require 'spec_helper'

describe Wor::Paginate do
  describe '.configure' do
    let(:original_default_adapter) { Wor::Paginate::Config.default_adapter }

    after do
      Wor::Paginate::Config.reset_adapters!
      Wor::Paginate::Config.default_adapter = original_default_adapter
    end

    it 'raises NoPaginationAdapter when no adapters or default adapter remain configured' do
      expect do
        described_class.configure do |config|
          config.clear_adapters
          config.default_adapter = nil
        end
      end.to raise_error(Wor::Paginate::Exceptions::NoPaginationAdapter)
    end
  end
end
