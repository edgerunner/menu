# coding: utf-8

require 'test_helper'

class RestaurantsControllerTest < ActionController::TestCase
  test "http://menu.dev should route to new on get and create on post" do
    assert_routing "http://menu.dev", {:action => "new" }.merge(default_options)
    assert_routing( {:method => :post, :path => "http://menu.dev"} , {:action => "create" }.merge(default_options))
  end
  
  test "should get new" do
    get :new, {:host => "menu.dev"}
    
    assert_response :success
    assert_not_nil assigns(:restaurant)
    assert_template "new"
    assert_template :partial => "_form"
    assert_template :partial => "_welcome"
  end
  
  test "proper restaurant creation" do
    assert_difference 'Restaurant.count' do
      post :create, :host => "menu.dev", :restaurant => proper_restaurant
    end
    assert_redirected_to root_url(:host => proper_restaurant[:domain], :port => request.port)
    assert_equal "Restoranın hazır", flash[:notice]
  end
  
  test "improper restaurant failed creation" do
    assert_no_difference "Restaurant.count" do  
      post :create, :host => "menu.dev", :restaurant => proper_restaurant.merge({:domain => "menu.dev"})
    end
    assert_template "new"
    assert_not_nil assigns(:restaurant)
    assert_present assigns(:restaurant).errors
    assert_equal assigns(:restaurant).name, proper_restaurant[:name]
    
    assert_select 'input#restaurant_name', :value => proper_restaurant[:name]
    assert_select '.errorExplanation ul li', :text => "Alan adı kullanılamaz"
  end
  
  test "editing nonexistant restaurant" do
    get :edit, :host => "none.dev"
    assert_nonexistant_domain_redirection
  end
  
  test "updating nonexistant restaurant" do
    assert_no_difference "Restaurant.count" do
      put :update, :host => "none.dev", :restaurant => proper_restaurant
    end
    assert_nonexistant_domain_redirection
  end

  test "updating existing restaurant" do
    foo = restaurants(:foo)
    
    @request.session[:restaurant_id] = foo.id
    @request.host = foo.domain
    
    put :update, :restaurant => { :name => "FooFoo" }
    assert_redirected_to root_url
    updated_foo = Restaurant.find(foo.id)
    assert_equal "FooFoo", updated_foo.name
  end
  
  test "illegal updating bar when logged in at foo" do
    foo, bar = restaurants(:foo), restaurants(:bar)
    
    @request.session[:restaurant_id] = foo.id
    @request.host = bar.domain
    
    put :update, :restaurant => { :name => "FooBar" }
    
    assert_redirected_to root_url
    assert_equal "Oraya girilmez birader", flash[:alert]
    
    updated_foo = Restaurant.find(foo.id)
    assert_equal "Foo", updated_foo.name
    updated_bar = Restaurant.find(bar.id)
    assert_equal "Bar", updated_bar.name
  end
  
  private
  
  def assert_nonexistant_domain_redirection
    assert_redirected_to restaurants_url(:port => request.port)
    assert_match /Bu alan adına kayıtlı bir restoran bulamadık/, flash[:alert]
  end
  
  def default_options
    {:host => "menu.dev", :controller => "restaurants"}
  end
  
  def proper_restaurant
    {
      :name => "My Restaurant",
      :domain => "my.menu.dev",
      :email => "test@example.com", 
      :password => "secret",
      :password_confirmation => "secret"
    }
  end
end
