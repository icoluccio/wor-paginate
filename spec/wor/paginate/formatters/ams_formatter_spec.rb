require 'spec_helper'

describe Wor::Paginate::Formatters::AmsFormatter do
  let!(:dummy_models) { create_list(:dummy_model, 3) }
  let(:adapter) { Wor::Paginate::Adapters::ActiveRecord.new(DummyModel.all, 1, 25) }
  let(:formatter) { described_class.new(adapter, options) }

  describe '#serialized_content' do
    context 'when the given serializer does not support ActiveModelSerializers attributes' do
      let(:options) { { each_serializer: DummyModelWithPankoSerializer } }

      it 'raises a DependencyError' do
        expect { formatter.serialized_content }
          .to raise_error(Wor::Paginate::Exceptions::DependencyError)
      end
    end
  end
end
