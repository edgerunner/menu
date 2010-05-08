class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery
  
  helper_method :admin?
  
  private
  
  def admin?
    @restaurant and session[:restaurant_id] == @restaurant.id
  end
  
  def set_restaurant
    @restaurant = Restaurant.find_by_domain(request.host)
    
    unless @restaurant
      flash[:restaurant] = Restaurant.new({:domain => request.host})
      redirect_to restaurants_url(:port => request.port)
    end
  end
  
end
