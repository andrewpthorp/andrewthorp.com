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

    should "call taggings.destroy before destroy" do
      post = create(:post)
      post.stubs(:taggings).returns(stub(destroy: true))
      post.taggings.expects(:destroy)
      post.destroy
    end

    should "not call taggings.destroy before destroy when !saved" do
      post = create(:post)
      post.stubs(:saved?).returns(false)
      post.stubs(:taggings).returns(stub(destroy: true))
      post.taggings.expects(:destroy).never
      post.destroy
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
