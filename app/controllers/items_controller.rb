class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :sold_out_item, only: [:edit]
  def index
    @items = Item.order('created_at DESC').includes(:user)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    redirect_to root_path  if current_user.id != @item.user_id
  end

  def update
    if current_user.id == @item.user_id && @item.update(item_params)
       redirect_to item_path(@item.id)
    else
       render :edit
    
    end
  end

  def destroy
    if current_user.id == @item.user_id
      @item.destroy
      redirect_to root_path
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :text, :category_id, :condition_id, :burden_id, :area_id, :day_id, :price,
                                 :image).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def sold_out_item
    redirect_to root_path if @item.buyer.present?
  end
end
