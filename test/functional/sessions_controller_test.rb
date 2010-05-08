require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Restaurant.stubs(:authenticate).returns(nil)
    post :create
    assert_template 'new'
    assert_nil session['restaurant_id']
  end
  
  def test_create_valid
    Restaurant.stubs(:authenticate).returns(Restaurant.first)
    post :create
    assert_redirected_to "/"
    assert_equal Restaurant.first.id, session['restaurant_id']
  end
end
