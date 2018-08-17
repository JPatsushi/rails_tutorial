class ItemsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :show, :update, :destroy]
  before_action :logged_in_user, only: [:index]
  before_action :find_item, only: [:show, :edit, :update, :destroy]
  
  def index
    if logged_in?
      @items = Item.where(:user_id => current_user.id).order("created_at DESC")
    end
  end
  
  def show
  end
  
  def new
    @item = current_user.items.build
  end
  
  def create
    @item = current_user.items.new(item_params)
    if @item.save
      redirect_to items_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render 'edit'
    end
  end
  
  def destroy
    @item.destroy
    redirect_to items_path
  end
  
  def complete
    @item = Item.find(params[:id])
    @item.update_attribute(:completed_at, Time.now)
    redirect_to items_path
  end
  
  private
  
    def item_params
      params.require(:item).permit(:title, :description)
    end
    
    def find_item
      @item = Item.find(params[:id])
    end

end
