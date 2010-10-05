class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :admin?
  
  private
  
  def admin?
    @restaurant and session[:restaurant_id] == @restaurant.id
  end
  
  def check_for_admin
    unless admin?
      redirect_to root_url, :alert => t("errors.app.denied")
    end
  end
  
  def set_restaurant
    @restaurant = Restaurant.find_by_domain(request.host)
    
    unless @restaurant
      flash[:restaurant] = Restaurant.new({:domain => request.host})
      redirect_to restaurants_url(:port => request.port), :alert => t("errors.app.no_restaurant")
    end
  end
  
end
