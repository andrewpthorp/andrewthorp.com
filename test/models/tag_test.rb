require 'test_helper'

class TagTest < MiniTest::Unit::TestCase
  def setup
    @tag = build(:tag)
  end

  # TODO: Extract this into more useful method
  def validate(obj, attr, val)
    obj.send("#{attr}=", val)
    obj.valid?
  end

  context "#validations" do
    should "validate presence of name" do
      validate(@tag, :name, nil)
      refute_nil @tag.errors[:name]
    end
  end

  context "#associations" do
    should "have n taggings" do
      assert Tag.relationships["taggings"].is_a? DataMapper::Associations::OneToMany::Relationship
    end

    should "have n posts through taggings" do
      rel = Tag.relationships["posts"]
      assert rel.is_a? DataMapper::Associations::ManyToMany::Relationship
      assert rel.through.is_a? DataMapper::Associations::OneToMany::Relationship
      assert_equal rel.through.child_model_name, "Tagging"
    end
  end
end
