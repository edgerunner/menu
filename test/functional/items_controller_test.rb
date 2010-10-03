require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  def setup
    @request.host = restaurants(:foo).domain
  end
  
  test "restaurant should always be set beforehand" do
    all_actions.each do |action, verb|
      send verb, action, id: items(:one).id
      assert assigns(:restaurant)
    end
  end
  
  test "public users should be allowed to only see the index" do
    get :index
    assert_template "index"
    assert_blank flash
    
    all_actions.except(:index).each do |action, verb|
      send verb, action, id: items(:one).id
      assert_redirected_to root_url
      assert_equal "Oraya girilmez birader", flash[:alert]
    end
  end
  
  test "root should route to items index" do
    assert_recognizes({controller: 'items', action: 'index'},{path: '/', method: :get})
  end
  
  test "index should get items" do
    get :index
    assert_equal 2, assigns(:items).count
  end
  
  
  
  private 
  
  def all_actions
    {index: :get, edit: :get, create: :post, update: :put}
  end
end
