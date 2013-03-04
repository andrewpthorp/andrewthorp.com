require 'test_helper'

class TaggingTest < MiniTest::Unit::TestCase
  context "#associations" do
    should "belong_to :post" do
      assert Tagging.relationships["post"].is_a? DataMapper::Associations::ManyToOne::Relationship
    end

    should "belong_to :tag" do
      assert Tagging.relationships["tag"].is_a? DataMapper::Associations::ManyToOne::Relationship
    end
  end
end
