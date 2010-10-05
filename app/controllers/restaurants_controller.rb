# coding: utf-8
class RestaurantsController < ApplicationController
  before_filter :set_restaurant, :check_for_admin, :only => [:edit, :update]
  
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
  
  def edit
  end
  
  def update
    @restaurant.update_attributes(params[:restaurant])
    if @restaurant.save
      redirect_to root_url, :notice => t('notice.restaurant.updated')
    else
      render 'edit'
    end
  end
end
