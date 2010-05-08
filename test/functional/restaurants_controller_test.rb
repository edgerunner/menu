require 'test_helper'

class RestaurantsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Restaurant.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Restaurant.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to "/"
    assert_equal assigns['restaurant'].id, session['restaurant_id']
  end
end
