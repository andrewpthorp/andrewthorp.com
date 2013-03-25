require 'test_helper'

class AndrewthorpTest < MiniTest::Unit::TestCase
  def assert_valid_response(route, method='get')
    self.send(method, route)
    assert (last_response.ok? || last_response.redirect?), "expected to respond to #{method.upcase} #{route}, but did not"
  end

  should "respond to GET '/'" do
    assert_valid_response "/"
  end

  should "respond to GET '/login'" do
    assert_valid_response "/login"
  end

  should "respond to POST '/sessions/create'" do
    assert_valid_response "/sessions/create", "post"
  end

  should "respond to GET '/logout'" do
    assert_valid_response "/logout"
  end

  should "respond to GET '/about'" do
    assert_valid_response "/about"
  end

  should "respond to GET '/posts'" do
    assert_valid_response "/posts"
  end

  should "respond to GET '/posts/all'" do
    assert_valid_response "/posts/all"
  end

  should "respond to GET '/posts/tagged/:tag'" do
    tag = create(:tag)
    assert_valid_response "/posts/tagged/#{tag.name}"
  end

  should "respond to GET '/posts/new'" do
    assert_valid_response "/posts/new"
  end

  should "respond to POST '/posts'" do
    assert_valid_response "/posts", "post"
  end

  should "respond to GET '/posts/:slug/edit'" do
    post = build(:post)
    post.save
    assert_valid_response "/posts/#{post.slug}/edit"
  end

  should "respond to GET '/posts/:slug/delete'" do
    post = build(:post)
    post.save
    assert_valid_response "/posts/#{post.slug}/delete"
  end

  should "respond to PUT '/posts/:slug'" do
    post = build(:post)
    post.save
    assert_valid_response "/posts/#{post.slug}", "put"
  end

  should "respond to GET '/posts/:slug'" do
    post = build(:post)
    post.save
    assert_valid_response "/posts/#{post.slug}"
  end

  should "respond to GET '/portfolio'" do
    assert_valid_response "/portfolio"
  end

  should "respond to GET '/resume'" do
    assert_valid_response "/resume"
  end

end
