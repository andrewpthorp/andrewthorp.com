require 'test_helper'

class PostTest < MiniTest::Unit::TestCase
  def setup
    @post = Post.new(title: "Foobar title", body: "Foobar body", published: true)
  end

  def test_pretty_body
    @post.body = "**strong**"
    assert_match @post.pretty_body, /<strong>/
  end

  def test_slug_creation
    @post.title = "This is a Sluggable title"
    @post.save
    assert_equal @post.slug, "this-is-a-sluggable-title"
  end

  def test_slug_creation_duplicates
    p = Post.new(title: "Foobar title", body: "foobar body", published: true)
    @post.save
    p.save
    assert_equal p.slug, "foobar-title-2"
  end

  def test_published_scope
    @post.save
    p = Post.create(title: "foobar", body: "foobar", published: false)
    assert Post.published == [@post], "published scope return unpublished Posts"
  end
end
