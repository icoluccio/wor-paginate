require 'spec_helper'

# Real HTTP paths, unlike the `type: :controller` specs, which bypass the router.
describe 'pagination over real HTTP routes', type: :request do
  describe 'GET /dummy_models' do
    let!(:model_count) { 28 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }
    let(:expected_list) { dummy_models.first(25).as_json(only: %i[id name something]) }

    before { get '/dummy_models' }

    include_context 'with default pagination params'

    include_examples 'proper pagination params'

    include_examples 'valid page'
  end

  describe 'GET /dummy_models/index_pagy' do
    let!(:model_count) { 28 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }
    let(:expected_list) { dummy_models.first(25).as_json(only: %i[id name something]) }

    before do
      [Wor::Paginate::Adapters::Kaminari, Wor::Paginate::Adapters::WillPaginate].each do |klass|
        allow_any_instance_of(klass).to receive(:adapt?).and_return(false)
      end
      get '/dummy_models/index_pagy'
    end

    include_context 'with default pagination params'

    include_examples 'proper pagination params'

    include_examples 'valid page'
  end

  describe 'GET /dummy_sons' do
    let!(:model_count) { 28 }
    let!(:dummy_models) { create_list(:dummy_model, model_count, :with_son) }

    before { get '/dummy_sons' }

    include_context 'with default pagination params'

    include_examples 'proper pagination params'
  end

  describe 'GET /dummy_models_total_count' do
    let!(:dummy_models) { create_list(:dummy_model, 9) }

    before { get '/dummy_models_total_count' }

    include_examples 'total count pagination param'
  end

  describe 'GET /dummy_models_without_gems' do
    let!(:model_count) { 28 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }
    let(:expected_list) { dummy_models.first(25).as_json(only: %i[id name something]) }

    before do
      [Wor::Paginate::Adapters::Kaminari, Wor::Paginate::Adapters::WillPaginate,
       Wor::Paginate::Adapters::Pagy].each do |klass|
        allow_any_instance_of(klass).to receive(:adapt?).and_return(false)
      end
      get '/dummy_models_without_gems'
    end

    include_context 'with default pagination params'

    include_examples 'proper pagination params'

    include_examples 'valid page'
  end
end
