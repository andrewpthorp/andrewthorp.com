require 'test_helper'

# TODO: This has WAY too much implementation detail in it. It does, however,
# serve the purpose of my tests, which are just checking for the content of
# the methods. I don't care to know how link_to or content_tag work, because
# that is handled in sinatra_more/markup_plugin. That being said, there has
# to be a better way to do this.
class MockNav
  include NavigationHelper

  def link_to(content, url, opts={})
    c = opts[:class] || ''
    ta = opts[:target] || ''
    ti = opts[:title] || ''

    "<a href='#{url}' class='#{c}' target='#{ta}' title='#{ti}'>#{content}'</a>"
  end

  def content_tag(tag, content, opts={})
    c = opts[:class] || ''
    id = opts[:id] || ''

    if content.is_a?(Array)
      content = content.join(" ")
    end

    "<#{tag.to_s} id='#{id}' class='#{c}'>#{content}</#{tag.to_s}>"
  end
end

class NavigationHelperTest < MiniTest::Unit::TestCase
  def setup
    @helper = MockNav.new

    request = stub(:fullpath => '/foo')
    @helper.stubs(:request).returns(request)
  end

  context '#social_navigation' do
    should 'have a link to twitter' do
      assert_match 'twitter.com/andrewpthorp', @helper.social_navigation
    end

    should 'have a link to facebook' do
      assert_match 'twitter.com/andrewpthorp', @helper.social_navigation
    end

    should 'have a link to github' do
      assert_match 'twitter.com/andrewpthorp', @helper.social_navigation
    end

    context 'when passing a class into the method' do
      should 'put that class on the ul' do
        assert_match "<ul id='social-nav' class='foo'",
          @helper.social_navigation(class: 'foo')
      end
    end
  end

  context '#site_navigation' do
    setup do
      @helper.stubs(:user_signed_in?).returns(false)
    end

    should 'have a link to home' do
      assert_match "href='/'", @helper.site_navigation
    end

    should 'have a link to about' do
      assert_match "href='/about'", @helper.site_navigation
    end

    should 'have a link to posts' do
      assert_match "href='/posts'", @helper.site_navigation
    end

    should 'have a link to projects' do
      assert_match "href='/projects'", @helper.site_navigation
    end

    should 'have a link to resume' do
      assert_match "href='/resume'", @helper.site_navigation
    end

    context 'when passing a class into the method' do
      should 'put that class on the ul' do
        assert_match "<ul id='site-nav' class='foo'",
          @helper.site_navigation(class: 'foo')
      end
    end

    context 'when a user is logged in' do
      setup do
        @helper.stubs(:user_signed_in?).returns(true)
      end

      should 'have a link to new post' do
        assert_match "href='/posts/new'", @helper.site_navigation
      end

      should 'have a link to logout' do
        assert_match "href='/logout'", @helper.site_navigation
      end

      should 'not have a link to login' do
        refute_match "href='/login'", @helper.site_navigation
      end
    end

    context 'when a user is not logged in' do
      should 'have a link to login' do
        assert_match "href='/login", @helper.site_navigation
      end

      should 'not have a link to logout' do
        refute_match "href='/logout", @helper.site_navigation
      end

      should 'not have a link to new post' do
        refute_match "href='/posts/new", @helper.site_navigation
      end
    end
  end
end
