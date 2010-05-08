class RestaurantsController < ApplicationController
  
  def new
    @restaurant = flash[:restaurant] || Restaurant.new
  end
  
  def create
    @restaurant = Restaurant.new(params[:restaurant])
    if @restaurant.save
      session[:restaurant_id] = @restaurant.id
      redirect_to root_url(:host => @restaurant.domain, :port => request.port), :notice => t('notice.restaurant.created')
    else
      render :action => 'new'
    end
  end
end
