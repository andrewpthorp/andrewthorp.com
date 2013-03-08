require 'test_helper'

# Stubbint this out for tests
class Post
  PER_PAGE = 10
end

class PostTest < MiniTest::Unit::TestCase
  def setup
    @post = build(:post)
  end

  context "::CLASS_VARS" do
    should "set PER_PAGE as an Integer" do
      assert Post::PER_PAGE.is_a?(Integer), "expected Post::PER_PAGE to be an Integer, but it was a #{Post::PER_PAGE.class.to_s}"
    end
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

  context "#associations" do
    should "have n taggings" do
      assert Post.relationships["taggings"].is_a? DataMapper::Associations::OneToMany::Relationship
    end

    should "have n tags through taggings" do
      rel = Post.relationships["tags"]
      assert rel.is_a? DataMapper::Associations::ManyToMany::Relationship
      assert rel.through.is_a? DataMapper::Associations::OneToMany::Relationship
      assert_equal rel.through.child_model_name, "Tagging"
    end
  end

  context "#hooks" do
    should "call set_slug before create" do
      post = build(:post)
      post.expects(:set_slug).with(post.title.to_slug)
      post.save
    end
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

  context "#methods" do
    context "#pages" do
      should "return the correct number of pages" do
        Post.stubs(:count).returns(20)
        assert_equal 2, Post.pages
      end

      should "allow count to land between pages" do
        Post.stubs(:count).returns(12)
        assert_equal 2, Post.pages
      end

      should "return 1 if count is less than PER_PAGE" do
        Post.stubs(:count).returns(8)
        assert_equal 1, Post.pages
      end

      should "allow me to pass per_page in" do
        Post.stubs(:count).returns(10)
        assert_equal 5, Post.pages(2)
      end
    end

    context "#page" do
      setup do
        @npost = create(:post)
      end

      should "return the right results" do
        assert_equal [@npost], Post.page(1)
      end

      should "default to page one" do
        assert_equal [@npost], Post.page
      end

      should "convert nil to page one" do
        assert_equal [@npost], Post.page(nil)
      end

      should "convert string to integer" do
        assert_equal [@npost], Post.page("1")
      end

      should "return an empty array if past the last page" do
        assert_equal [], Post.page(2)
      end

      should "allow me to set per_page" do
        @spost = create(:post)
        assert_equal [@npost], Post.page(1, 1)
      end
    end
  end

  context ".methods" do
    context ".set_slug" do
      should "create a valid slug on save" do
        @post.set_slug(@post.title.to_slug)
        assert_equal @post.slug, "foobar-title"
      end

      should "prevent duplicate slugs" do
        @post.save
        p = build(:post)
        p.set_slug(p.title.to_slug)
        assert_equal p.slug, "foobar-title-2"
      end
    end

    context ".pretty_body" do
      should "render markdown" do
        @post.body = "**strong**"
        assert_match @post.pretty_body, /<strong>/
      end
    end

    context ".tag_list" do
      should "return array of tags" do
        @post.save
        @post.tag_list = "some, tags"
        assert_equal @post.tag_list, ["some", "tags"]
      end
    end

    context ".tag_list=" do
      should "set @tag_list" do
        @post.save
        @post.tag_list = "some, tags, cray, yo"
        assert_equal @post.tag_list, ["cray", "some", "tags", "yo"]
      end

      should "call update_tags" do
        @post.save
        @post.expects(:update_tags)
        @post.tag_list = "some, tags"
      end
    end

    context ".tag_collection" do
      should "return comma separated tag_list" do
        @post.save
        @post.tag_list = "these, tags, cray"
        assert_equal @post.tag_collection, "cray, tags, these"
      end
    end

    context ".update_tags" do
      should "set tags" do
        @post.save
        @post.stubs(:tag_list).returns(["some"])
        tags = [Tag.new(name: "some")]
        @post.expects(:tags=).with(tags)
        @post.update_tags
      end
    end
  end

end
