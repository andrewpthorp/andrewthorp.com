require 'test_helper'

class MockView
  include ViewHelper
end

class ViewHelperTest < MiniTest::Unit::TestCase
  def setup
    @helper = MockView.new
  end

  context '#emojify' do
    should 'inject images if the emoji exists' do
      assert_match '/images/emoji/beers.png', @helper.emojify('some :beers:')
    end

    should 'not inject images if the emoji does not exist' do
      assert_equal ':thisdoesnotexist:', @helper.emojify(':thisdoesnotexist:')
    end
  end

  context '#classify' do
    [
      { tag: 'sports', emoji: 'baseball' },
      { tag: 'the-changelog', emoji: 'computer' },
      { tag: 'development', emoji: 'computer' },
      { tag: 'personal', emoji: 'beers' }
    ].each do |r|
      context "when the first tag is #{r[:tag]}" do
        should "return image tag for emoji :#{r[:emoji]}:" do
          post = Post.new(tags: [Tag.new(name: r[:tag])])
          assert_match "/images/emoji/#{r[:emoji]}.png", @helper.classify(post)
        end
      end
    end
  end

end
