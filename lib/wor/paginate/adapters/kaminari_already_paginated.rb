# Used when render_paginated is called with an already paginated ActiveModel with kaminari
### render_paginated DummyModel.page
module Wor
  module Paginate
    module Adapters
      class KaminariAlreadyPaginated < Base
        def required_methods
          # Methods Kaminari adds to ActiveRecord relations:
          ### [:padding, :per, :total_pages, :current_page, :first_page?,
          ### :prev_page, :last_page?, :next_page, :out_of_range?, :total_count, :entry_name]
          # NOTE: `num_pages` was removed upstream (kaminari-core 1.2.2's
          # lib/kaminari/models/page_scope_methods.rb only defines
          # `total_pages`); checking for it here always returned false,
          # so `adapt?` never matched and already-paginated Kaminari
          # content silently fell through to the wrong adapter.
          %i[padding total_count total_pages current_page prev_page]
        end

        def paginated_content
          @paginated_content ||= @content.page(@page).per(@limit)
        end

        def count
          @content.count
        end

        def total_count
          @content.total_count
        end

        def total_pages
          @content.total_pages
        end
      end
    end
  end
end
