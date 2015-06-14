class LineItemsController < ApplicationController

  before_action :set_line_item, only: [:update, :destroy]
  # before_action :current_cart, only: [:create]

  def create
    if cookies[:cart_id].nil?
      cart = Cart.create
      cookies[:cart_id] = { value: cart.id, expires: 1.week.from_now }
    end
    product = Product.find(params[:product_id])
    @line_item = current_cart.add_product(product.id, product.price)
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to :back }
        format.js
      else
        format.html { redirect_to store_path flash[:error] = "Can't create line item" }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to :back }
        format.js { @current_item = @line_item }
      else
        format.html { redirect_to :back }
      end
    end
  end

  # def destroy
  #   @line_item.destroy
  #   respond_to do |format|
  #     if current_cart.line_items.empty?
  #       current_cart.destroy
  #       session[:cart_id] = nil
  #       format.html { redirect_to store_url flash[:info] = 'Your cart is empty' }
  #       format.js { render 'destroy_last' }
  #     else
  #       format.html { redirect_to current_cart }
  #       format.js
  #     end
  #   end
  # end

  def destroy
    @line_item.destroy
    if cookies[:cart_id] != nil
      respond_to do |format|
        if current_cart.line_items.empty?
          current_cart.destroy
          cookies.delete :cart_id
          format.html { redirect_to carts_path flash[:info] = 'Cart is empty' }
          format.js { render 'destroy_last' }
        else
          format.html { redirect_to current_cart }
          format.js
        end
      end
    else
      order = Order.find(@line_item.order)
      if order.line_items.empty?
        order.destroy
        redirect_to orders_path
      else
        redirect_to :back
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity, :order_id)
  end
end
