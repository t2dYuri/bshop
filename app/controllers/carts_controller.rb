class CartsController < ApplicationController

  before_action :set_cart, only: [:show, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def index
    @carts = Cart.all
  end

  def show
    if @cart != current_cart
      redirect_to store_path flash[:error] = 'Invalid cart'
    end
  end

  def destroy
    @cart.destroy
    # current_cart.destroy
    session[:cart_id] = nil
    redirect_to :back, notice: 'Cart destroyed'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end

  def invalid_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to store_url flash[:error] = 'Invalid cart'
  end
end
