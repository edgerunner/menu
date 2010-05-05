class ItemsController < ApplicationController
  
  def index
    #I18n.locale = :en
    @date = Date.today
    @items = Item.all
    if admin?
      @form_item = flash[:item] || Item.new
      @items << @form_item unless @items.include?(@form_item)
    end
  end
  
  def edit
    flash[:item] = Item.find(params[:id])
    redirect_to items_url
  end

  def create
    @item = Item.new(params[:item])
    
    if @item.save
      redirect_to :back, :notice => t(:'notice.item.created', :name => @item.name) 
    else
      flash[:item] = @item
      redirect_to items_url(:anchor => "errorExplanation"), :alert => t(:'errors.models.created', :name => t(:'activerecord.models.item'))
    end
  end
  
  def update
    updater do
      @item.attributes = params[:item]
    end
  end
  
  
  def destroy
    @item = Item.find(params[:id])
    
    if @item.destroy
      redirect_to :back, :notice => t(:'notice.item.deleted', :name => @item.name) 
    else
      redirect_to items_url, :alert => t(:'errors.models.deleted', :name => t(:'activerecord.models.item'))
    end
  end
  
  def expire
    updater do
      @item.active = false
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
    @item = Item.find(params[:id])
    
    yield
    
    if @item.save
      redirect_to :back, :notice => t(:'notice.item.updated', :name => @item.name) 
    else
      flash[:item] = @item
      redirect_to items_url(:anchor => "errorExplanation"), :alert => t(:'errors.models.updated', :name => @item.name)
    end
  end
  
end
