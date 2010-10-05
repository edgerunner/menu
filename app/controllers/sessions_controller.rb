# coding: utf-8
class SessionsController < ApplicationController
  before_filter :set_restaurant
  
  def new
  end
  
  def create
    if @restaurant.matching_password? params[:password]
      session[:restaurant_id] = @restaurant.id
      redirect_to root_url, :notice => t('notice.session.created')
    else
      redirect_to login_url, :alert => t('errors.session.wrong_password')
    end
  end
  
  def destroy
    session[:restaurant_id] = nil
    redirect_to root_url, :notice => t('notice.session.deleted')
  end
end
