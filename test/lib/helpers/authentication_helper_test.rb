require 'test_helper'

class MockAuth
  include AuthenticationHelper
  include Rack::Test::Methods

  def session
    @session ||= {}
  end

  def ENV
    @ENV ||= {}
  end
end

class AuthenticationHelperTest < MiniTest::Unit::TestCase
  def setup
    @helper = MockAuth.new
  end

  context '#current_user=' do
    should 'set the current user in the session' do
      @helper.current_user = 'andrew'
      assert_equal 'andrew', @helper.session[:current_user]
    end
  end

  context '#current_user' do
    should 'return the current user in the session' do
      @helper.session[:current_user] = 'foo'
      assert_equal 'foo', @helper.current_user
    end
  end

  context '#user_signed_in?' do
    context 'when the session includes the key current_user' do
      should 'return true' do
        @helper.session[:current_user] = 'andrew'
        assert_equal true, @helper.user_signed_in?
      end
    end

    context 'when the session does not include the key current_user' do
      should 'return false' do
        @helper.session.delete(:current_user)
        assert_equal false, @helper.user_signed_in?
      end
    end
  end

  context '#auth_user_from_env' do
    should 'set the current user from the ENV in the session' do
      ENV['ADMIN_USERNAME'] = 'apthorp'
      @helper.auth_user_from_env
      assert_equal 'apthorp', @helper.session[:current_user]
    end
  end

  context '#auth_result_hash' do
    context 'when the user is signed in' do
      should 'return the correct result' do
        @helper.stubs(:user_signed_in?).returns(true)
        @helper.stubs(:return_to).returns('/')
        @helper.stubs(:current_user).returns('andrew')
        assert_equal( { success: true, user: 'andrew', return: '/' },
                      @helper.auth_result_hash )
      end
    end

    context 'when the user is not signed in' do
      should 'return the correct result' do
        @helper.stubs(:user_signed_in?).returns(false)
        assert_equal({ success: false }, @helper.auth_result_hash)
      end
    end
  end

  context '#valid_password?' do
    setup do
      ENV['ADMIN_PASSWORD'] = 'password'
    end

    context 'when the param is equal to the password in ENV' do
      should 'return true' do
        assert_equal true, @helper.valid_password?('password')
      end
    end

    context 'when the param is not equal to the password in ENV' do
      should 'return false' do
        assert_equal false, @helper.valid_password?('foo')
      end
    end
  end

  context '#return_to=' do
    should 'set the return_to in the session' do
      @helper.return_to = '/some/path'
      assert_equal '/some/path', @helper.session[:return_to]
    end
  end

  context '#return_to' do
    setup do
      @helper.session[:return_to] = '/some/path'
    end

    should 'return the return_to stored in the session' do
      assert_equal '/some/path', @helper.return_to
    end

    context 'when true is passed as a parameter' do
      should 'delete the return_to from the session' do
        @helper.return_to(true)
        assert_nil @helper.session[:return_to]
      end
    end
  end

  context '#protected!' do
    context 'when a user is signed in' do
      setup do
        @helper.stubs(:user_signed_in?).returns(true)
      end

      should 'not redirect' do
        @helper.expects(:redirect).never
        @helper.protected!
      end

      should 'not add return_to to the session' do
        @helper.protected!
        assert_nil @helper.session[:return_to]
      end
    end

    context 'when a user is not signed in' do
      setup do
        @helper.stubs(:user_signed_in?).returns(false)
        @helper.stubs(:request).returns(mock(fullpath: '/some/full/path'))
        @helper.stubs(:redirect)
      end

      context 'without any parameters' do
        should 'redirect to /login' do
          @helper.expects(:redirect).with('/login')
          @helper.protected!
        end
      end

      context 'with a failure_path as a parameter' do
        should 'redirect to the parameter' do
          @helper.expects(:redirect).with('/some/path')
          @helper.protected!('/some/path')
        end
      end

      should 'set the return_to in the session' do
        @helper.protected!
        assert_equal '/some/full/path', @helper.session[:return_to]
      end
    end
  end

  context '#prduction?' do
    should 'return true if the RACK_ENV is production' do
      ENV['RACK_ENV'] = 'production'
      assert_equal true, @helper.production?
    end

    should 'return false if the RACK_ENV is not production' do
      ENV['RACK_ENV'] = 'test'
      assert_equal false, @helper.production?
    end
  end
end
