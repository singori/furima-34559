class BuyersController < ApplicationController

  def index
    @item = Item.find(params[:item_id])
    @buyer_shipping_address = BuyerShippingAddress.new
  end
  
  def create
    @item = Item.find(params[:item_id])
    @buyer_shipping_address = BuyerShippingAddress.new(buyer_params)
    if @buyer_shipping_address.valid?
      pay_item
      @buyer_shipping_address.save
      redirect_to root_path
    else
      render :index
    end
  end

  private
  def buyer_params
    params.require(:buyer_shipping_address).permit(:postal_code, :prefecture_id, :municipalities, :address, :builing_name, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def pay_item
    Payjp.api_key = "sk_test_d11fcdcd4267e2b4f29404a7"  
    Payjp::Charge.create(
      amount: Item.find(params[:item_id]).price,
      card: buyer_params[:token],    
      currency: 'jpy'                 
    )
  end
end
