module Pageable

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Query for the total number of pages.
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

    # Query for a specific page.
    def page(page = 1, per_page = ancestors.first::PER_PAGE)
      page = 1 if page.nil?
      page = page.to_i unless page.is_a? Integer

      offset = (page - 1) * per_page
      all[offset, per_page]
    end
  end

end
