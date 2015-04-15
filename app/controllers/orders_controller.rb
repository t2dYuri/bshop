class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :current_cart, only: [:new, :create]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    if current_cart.line_items.empty?
      redirect_to store_url, notice: 'Your cart is empty'
      return
    end
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.add_cart_line_items(current_cart)
    if @order.save
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to store_url, notice: 'Thank you for your order.'
    else
      render :new
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
end
