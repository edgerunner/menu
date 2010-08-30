class ItemsController < ApplicationController
  before_filter :set_restaurant
  before_filter :check_for_admin, :except => :index
  
  def index
    @date = Date.today

    @items = @restaurant.items.all
    
    if admin?
      @form_item = flash[:item] || @restaurant.items.build
    end
  end
  
  def edit
    flash[:item] = Item.find(params[:id])
    redirect_to root_url
  end

  def create
    @item = @restaurant.items.build(params[:item])
    
    if @item.valid?
      @item.save!
      notice = t(:'notice.item.created', :name => @item.name)
      redirect_to :back
    else
      alert = t(:'errors.models.created', :name => t(:'activerecord.models.item'))
      flash[:item] = @item
      redirect_to root_url(:anchor => "errorExplanation")
    end
  end
  
  def update
    updater do
      @item.update_attributes params[:item]
    end
  end
  
  
  def destroy
    @item = Item.find(params[:id])
    
    if @item.destroy
      flash.notice = t(:'notice.item.deleted', :name => @item.name)
      redirect_to :back 
    else
      flash.alert = t(:'errors.models.deleted', :name => @item.name)
      redirect_to root_url
    end
  end
  
  def destroy_all
    if @restaurant.items.destroy_all.length > 0
      flash.notice = t(:'notice.item.deleted_all')
    else
      flash.alert = t(:'errors.models.deleted_all')
    end
    redirect_to root_url
  end
      
  def expire
    updater do
      @item.active = false
    end
  end
  
  def renew
    updater do
      @item.active = true
    end
  end
  
  def up
    updater do
      @item.move_higher
    end
  end
  
  def down
    updater do
      @item.move_lower
    end
  end
  
  private
  
  def updater
    @item = @restaurant.items.find(params[:id])
    
    yield
    
    if @item.valid?
      @item.save!
      flash.notice = t(:'notice.item.updated', :name => @item.name)
      redirect_to :back
    else
      flash.alert = t(:'errors.models.updated', :name => @item.name)
      flash[:item] = @item
      redirect_to root_url(:anchor => "errorExplanation")
    end
  end
  
end
