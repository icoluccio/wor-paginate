require 'spec_helper'

describe Wor::Paginate::Formatters::PankoFormatter do
  let!(:dummy_models) { create_list(:dummy_model, 3) }
  let(:adapter) { Wor::Paginate::Adapters::ActiveRecord.new(DummyModel.all, 1, 25) }
  let(:formatter) do
    described_class.new(adapter, each_serializer: DummyModelWithPankoSerializer)
  end

  describe '#serialized_content' do
    it 'retries once when ActiveRecord::StatementInvalid is raised' do
      call_count = 0
      allow_any_instance_of(Panko::ArraySerializer).to receive(:to_a) do
        call_count += 1
        raise ActiveRecord::StatementInvalid if call_count == 1

        []
      end

      expect(formatter.serialized_content).to eq([])
      expect(call_count).to eq(2)
    end
  end
end
