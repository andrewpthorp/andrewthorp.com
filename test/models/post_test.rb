require 'test_helper'

class PostTest < MiniTest::Unit::TestCase
  def setup
    @post = build(:post)
  end

  # TODO: Extract this into more useful method
  def validate(obj, attr, val)
    obj.send("#{attr}=", val)
    obj.valid?
  end

  context "#validations" do
    should "validate presence of title" do
      validate(@post, :title, nil)
      refute_nil @post.errors[:title]
    end

    should "validate presence of body" do
      validate(@post, :body, nil)
      refute_nil @post.errors[:body]
    end

    should "validate presence of published" do
      validate(@post, :published, nil)
      refute_nil @post.errors[:published]
    end
  end

  context ".methods" do
    context ".set_slug" do
      should "create a valid slug" do
        @post.save
        assert_equal @post.slug, "foobar-title"
      end

      should "prevent duplicate slugs" do
        @post.save
        p = build(:post)
        p.save
        assert_equal p.slug, "foobar-title-2"
      end
    end

    context ".pretty_body" do
      should "render markdown" do
        @post.body = "**strong**"
        assert_match @post.pretty_body, /<strong>/
      end
    end
  end

  context "#methods" do
  end

  context "#scopes" do
    context "#published" do
      should "return published posts" do
        @post.save
        p = build(:post, published: false)
        p.save
        assert Post.published == [@post], "published scope return unpublished Posts"
      end
    end
  end

end
