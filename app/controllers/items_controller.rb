class ItemsController < ApplicationController
  def index
    #I18n.locale = :en
    @date = params[:date] || Date.today
    @items = Item.all
    @new_item = Item.new
  end



  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])
    
    if @item.save
      redirect_to(items_url, :notice => t(:'notice.item.created', :name => @item.name))
    else
      render :items
    end

  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end
end
