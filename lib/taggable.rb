module Taggable

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Get all Posts tagged with a string
    def tagged_with(string, options = {})
      tag = Tag.first(name: string)
      conditions = {
        'taggings.tag_id' => tag.kind_of?(Tag) ? tag.id : nil
      }
      all(conditions.update(options))
    end
  end

  # Get tag_list for a specific instance.
  def tag_collection
    @tag_collection ||= tags.map(&:name)
  end

  # Set tag_list on a specific instance.
  def tag_list=(string)
    @tag_collection = string.to_s.split(',').map { |name| name.strip }.uniq.sort
    update_tags
  end

  # Helper for HTML forms.
  def tag_list
    tags.map { |tag| tag.name }.join(', ')
  end

  # This actually sets the tags prior to saving an instance.
  def update_tags
    self.tags = tag_collection.map { |name| Tag.first_or_new(name: name) }
  end

end
