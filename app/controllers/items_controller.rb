class ItemsController < ApplicationController
  before_filter :set_restaurant
  before_filter :check_for_admin, :except => :index
  
  def index
    @date = Date.today

    @items = @restaurant.items
    
    if admin? and 
      @form_item = flash.has_key?(:item) ? flash[:item] : @restaurant.items.build
      @items << @form_item unless @items.include?(@form_item)
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
      notice = t(:'notice.item.deleted', :name => @item.name)
      redirect_to :back 
    else
      alert = t(:'errors.models.deleted', :name => t(:'activerecord.models.item'))
      redirect_to root_url
    end
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
      notice = t(:'notice.item.updated', :name => @item.name)
      redirect_to :back
    else
      alert = t(:'errors.models.updated', :name => @item.name)
      flash[:item] = @item
      redirect_to root_url(:anchor => "errorExplanation")
    end
  end
  
end
