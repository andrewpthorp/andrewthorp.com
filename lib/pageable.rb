# Public: This module allows me to paginate over the model that includes it.
#
# Examples
#
#   class Post
#     include Pageable
#   end
module Pageable

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Public: This method returns the total number of pages that are available
    # for the model that has included the Pageable module.
    #
    # per_page  - The number of instances per page (default: PER_PAGE).
    # opts      - A Hash used to refine the selection (default: {}).
    #             :published    - Only include published instances.
    #             :query        - Refine pages to models matching given query.
    #             :query_args   - Refine pages to models matching given query.
    #                             This attribute is required if :query is also
    #                             included. If only one or the other are
    #                             included, they are both simply ignored.
    #
    # Returns an Integer.
    def pages(per_page = ancestors.first::PER_PAGE, opts={})
      if opts[:published]
        query = ancestors.first.published
      else
        query = ancestors.first
      end

      if !opts[:query] || opts[:query] == :all
        c = query.count
      elsif opts[:query_args].blank?
        c = query.send(opts[:query]).count
      else
        c = query.send(opts[:query], opts[:query_args]).count
      end

      return 1 if c < per_page
      (c.to_f / per_page).ceil
    end

    # Public: This method returns a page of the model that has included the
    # Pageable module.
    #
    # page      - The page offset to return (default: 1).
    # per_page  - The amount of models per page to return (default: PER_PAGE).
    #
    # Returns a DataMapper::Collection.
    def page(page = 1, per_page = ancestors.first::PER_PAGE)
      page = 1 if page.nil?
      page = page.to_i unless page.is_a? Integer

      offset = (page - 1) * per_page
      all[offset, per_page]
    end

  end

end
