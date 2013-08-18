# Public: A module that allows me to Tag other models. As of right now, the
# class that includes the Taggable module has to setup the relationships.
#
# TODO: Figure out if I want to bring the relationships into the module, and
# what else that would require (DataMapper::Resource, for example).
#
# Examples
#
#   class Post
#     include Taggable
#     has n :taggings, :constraint => :destroy
#     has n :tags, :through => :taggings
#   end
module Taggable

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Public: Return all instances of the model that have a Tag with the given
    # String as a name.
    #
    # string  - The String used to find the Tag.
    # options - A Hash used to refine the search. This is passed along to the
    #           query, so it should be a Hash that you would use in DataMapper
    #           (default: {}).
    #
    # Examples
    #
    #   Post.tagged_with('development')
    #   # => [Post, Post]
    #   Post.tagged_with('development', published: false)
    #   # => [Post(published: false)]
    #
    # Returns a DataMapper::Collection.
    def tagged_with(string, options = {})
      tag = Tag.first(name: string)
      conditions = {
        'taggings.tag_id' => tag.kind_of?(Tag) ? tag.id : nil
      }
      all(conditions.update(options))
    end
  end

  # Public: Get an Array of the Tag names that are associated with this model.
  #
  # Examples
  #
  #   Post.tag_collection
  #   # => ['sports', 'development']
  #
  # Returns an Array.
  def tag_collection
    @tag_collection ||= tags.map(&:name)
  end

  # Public: Set the Tags on this model. It first sets @tag_collection to an
  # Array of strings, then calls the update_tags method.
  #
  # string - A comma separated list of ag names. This can also be an Array.
  #
  # Returns nothing.
  def tag_list=(string)
    @tag_collection = string.to_s.split(',').map { |name| name.strip }.uniq.sort
    update_tags
  end

  # Public: Return a comma separated String of Tag names. This method is useful
  # for HTML forms.
  #
  # Returns a String.
  def tag_list
    tags.map { |tag| tag.name }.join(', ')
  end

  # Public: Set the Tags on the model. It relies on @tag_collection returning
  # an Array, and sets the Tags to the existing Tags (by name) or builds a new
  # one.
  #
  # Returns nothing.
  def update_tags
    self.tags = tag_collection.map { |name| Tag.first_or_new(name: name) }
  end

end
