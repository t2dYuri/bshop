class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :destroy]
  before_action :admin_only, only: :index

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def index
    @carts = Cart.all.includes(:line_items)
  end

  def show
    unless current_user.try(:admin?) || @cart == current_cart
      redirect_to store_path flash[:error] = 'Not allowed'
    end
  end

  def destroy
    if current_user.try(:admin?) || @cart == current_cart
      @cart.destroy
      cookies.delete :cart_id
      redirect_to :back, notice: 'Cart destroyed'
    else
      redirect_to store_path flash[:error] = 'Not allowed'
    end
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
