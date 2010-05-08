class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery
  
  helper_method :admin?
  
  private
  
  def admin?
    true
  end
  
  def set_restaurant
    @restaurant = Restaurant.find_by_domain(request.host)
    
    unless @restaurant
      flash[:restaurant] = Restaurant.new({:domain => request.host})
      redirect_to restaurants_url
    end
  end
  
#  def default_url_options
#    options = self.class.default_url_options
#    if options[:host] =~ /\.dev$/ then
#      options[:port] = 3000 
#    end
#    options
#  end
end
