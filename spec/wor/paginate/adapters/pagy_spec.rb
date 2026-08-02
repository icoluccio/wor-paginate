require 'spec_helper'

describe Wor::Paginate::Adapters::Pagy do
  describe '#index' do
    let!(:n) { 28 }
    let!(:n_page) { 25 }
    let!(:dummy_models) { create_list(:dummy_model, n) }

    context 'with results' do
      let(:adapter) { described_class.new(DummyModel.order(:id), 1, n_page) }

      it 'adapts when Pagy is loaded and the content is ActiveRecord-shaped' do
        expect(adapter.adapt?).to be true
      end

      it 'responds to required_methods' do
        expect(adapter.required_methods).not_to be_empty
      end

      it 'responds to count' do
        expect(adapter.count).to be n_page
      end

      it 'responds to total_count' do
        expect(adapter.total_count).to be n
      end

      it 'responds to total_pages' do
        expect(adapter.total_pages).to be 2
      end

      it 'responds to paginated_content with the correct page slice' do
        expect(adapter.paginated_content.map(&:id)).to eq dummy_models.first(n_page).map(&:id)
      end

      it 'has no previous_page on the first page' do
        expect(adapter.previous_page).to be_nil
      end

      it 'has a next_page' do
        expect(adapter.next_page).to be 2
      end
    end

    context 'when on the last page' do
      let(:adapter) { described_class.new(DummyModel.order(:id), 2, n_page) }

      it 'has no next_page' do
        expect(adapter.next_page).to be_nil
      end

      it 'has a previous_page' do
        expect(adapter.previous_page).to be 1
      end
    end

    context 'with an empty collection' do
      let!(:dummy_models) { [] }
      let(:adapter) { described_class.new(DummyModel.order(:id), 1, n_page) }

      it 'floors total_pages at 1 instead of 0' do
        expect(adapter.total_pages).to be 1
      end

      it 'has no next_page' do
        expect(adapter.next_page).to be_nil
      end
    end
  end
end
