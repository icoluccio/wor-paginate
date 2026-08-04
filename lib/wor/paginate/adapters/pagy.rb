require_relative 'helpers/total_count'

# Used when render_paginated is called with an ActiveRecord directly, with the
# pagy gem loaded. Something like
### render_paginated DummyModel
module Wor
  module Paginate
    module Adapters
      class Pagy < Base
        include Helpers::TotalCount

        def adapt?
          defined?(::Pagy::Offset) && super
        end

        def required_methods
          %i[offset limit table_name]
        end

        def paginated_content
          @paginated_content ||= pagy.records(@content)
        end

        delegate :count, to: :paginated_content

        def total_pages
          pagy.pages
        end

        def next_page
          pagy.next
        end

        def previous_page
          pagy.previous
        end

        private

        def pagy
          @pagy ||= ::Pagy::Offset.new(count: total_count, page: @page, limit: @limit)
        end
      end
    end
  end
end
