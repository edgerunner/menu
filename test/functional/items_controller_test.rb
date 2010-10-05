# coding: utf-8
require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  def setup
    @request.host = restaurants(:foo).domain
  end
  
  test "restaurant should always be set beforehand" do
    all_actions.each do |action, verb|
      send verb, action, id: items(:one).id
      assert_same restaurants(:foo).id, assigns(:restaurant).id
    end
  end
  
  test "public users should be allowed to only see the index" do
    assert_public_access
  end
  
  test "root should route to items index" do
    assert_recognizes({controller: 'items', action: 'index'},{path: '/', method: :get})
  end
  
  test "index should get items" do
    get :index
    assert_equal 2, assigns(:items).count
  end
  
  test "edit should redirect to root url with item in the flash" do
    logged_in_as :foo
    get :edit, id: items(:one).id
    assert_redirected_to root_url
    assert_equal items(:one), flash[:item]
  end
  
  test "index should set @form_item to what is passed in flash[:item]" do
    logged_in_as :foo
    
    get :index, nil, nil, {item: items(:one)} # parameters, session, flash
    assert_same items(:one), assigns(:form_item)
  end
  
  test "logged in user should be able to access everything" do
    logged_in_as :foo
    
    get :index
    assert_response :success
    
    all_actions.except(:index).each do |action, verb|
      send verb, action, id: items(:one).id
      assert_response :redirect, "#{verb.upcase} #{action} should respond with a redirect but was #{@response.status}"
    end
  end
  
  test "another logged in user should be allowed only the index" do
    logged_in_as :bar
    assert_public_access
  end

  test "PUT /down should increase position" do
    logged_in_as :foo
    
    assert_difference "Item.find(items(:one).id).position" do
      put :down, id: items(:one).id
    end
  end

  test "PUT /up should decrease position" do
    logged_in_as :foo
    
    assert_difference "Item.find(items(:two).id).position", -1 do
      put :up, id: items(:two).id
    end
  end

  private 
  
  def logged_in_as restaurant
    @request.session[:restaurant_id] = case restaurant
      when Symbol then restaurants(restaurant).id
      when Restaurant then restaurant.id
      when Numeric then restaurant
      else nil
    end 
  end
  
  def all_actions
    {
      index:       :get, 
      edit:        :get, 
      create:      :post, 
      update:      :put,
      expire:      :put,
      renew:       :put,
      up:          :put,
      down:        :put,
      destroy:     :delete, # Keep delete events on the lowest level 
      destroy_all: :delete  # so that they don't mess up the test db too early
    }
  end
  
  def assert_public_access
    get :index
    assert_response :success
    
    all_actions.except(:index).each do |action, verb|
      send verb, action, id: items(:one).id
      assert_redirected_to root_url
      assert_equal "Oraya girilmez birader", flash[:alert]
    end
  end
  
end
