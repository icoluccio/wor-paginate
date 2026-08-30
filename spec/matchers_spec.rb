require 'spec_helper'

describe DummyModelsController, type: :controller do
  let!(:model_count) { 28 }
  let!(:dummy_models) { create_list(:dummy_model, model_count) }
  let(:expected_list) { dummy_models.first(25).as_json(only: %i[id name something]) }

  describe '#be_paginated' do
    context 'when using response_body' do
      it 'checks that the response keys matches with the default formatter' do
        get :index
        expect(response_body(response)).to be_paginated
      end

      it 'checks that the response is not paginated with the default formatter' do
        get :index_custom_formatter
        expect(response_body(response)).not_to be_paginated
      end
    end

    context 'when using response' do
      it 'checks that the response keys matches with the default formatter' do
        get :index
        expect(response).to be_paginated
      end

      it 'checks that the response is not paginated with the default formatter' do
        get :index_custom_formatter
        expect(response).not_to be_paginated
      end
    end
  end

  describe '#be_paginated failure messages' do
    it 'describes the key mismatch when the positive expectation fails' do
      get :index_custom_formatter
      expect { expect(response_body(response)).to be_paginated }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected keys/)
    end

    it 'describes the mismatch when the negated expectation fails' do
      get :index
      expect { expect(response_body(response)).not_to be_paginated }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError,
                        /not to be paginated with keys/)
    end

    it 'describes which field value mismatched' do
      get :index
      expect { expect(response_body(response)).to be_paginated.with_total_count(999) }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError,
                        /expected total_count to be 999/)
    end
  end

  describe '#be_paginated with field chain matchers' do
    before { get :index }

    it 'passes when total_count matches' do
      expect(response).to be_paginated.with_total_count(model_count)
    end

    it 'passes when current_page matches' do
      expect(response).to be_paginated.with_current_page(1)
    end

    it 'passes when next_page matches' do
      expect(response).to be_paginated.with_next_page(2)
    end

    it 'passes when previous_page matches' do
      expect(response).to be_paginated.with_previous_page(nil)
    end

    it 'passes when count matches' do
      expect(response).to be_paginated.with_count(25)
    end

    it 'passes when total_pages matches' do
      expect(response).to be_paginated.with_total_pages(2)
    end

    it 'passes when multiple chains are combined' do
      expect(response).to be_paginated
        .with_total_count(model_count)
        .with_current_page(1)
        .with_next_page(2)
    end

    it 'fails when the value does not match' do
      expect(response).not_to be_paginated.with_total_count(999)
    end
  end

  describe '#be_paginated.with' do
    context 'when using response_body' do
      it 'checks that the response keys matches with the custom formatter' do
        get :index_custom_formatter
        expect(response_body(response)).to be_paginated.with(CustomFormatter)
      end
    end

    context 'when using response' do
      it 'checks that the response keys matches with the custom formatter' do
        get :index_custom_formatter
        expect(response).to be_paginated.with(CustomFormatter)
      end
    end
  end
end
