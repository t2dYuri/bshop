class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_cart

  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  # def current_cart
  #   @cart = Cart.find(session[:cart_id])
  # rescue ActiveRecord::RecordNotFound
  #   @cart = Cart.create
  #   session[:cart_id] = @cart.id
  # end
end
