class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def current_cart
    Cart.find cookies[:cart_id]
  rescue ActiveRecord::RecordNotFound
    cookies.delete :cart_id
    redirect_to store_path and return

  # rescue ActiveRecord::RecordNotFound
  #   cart = Cart.create
  #   session[:cart_id] = cart.id
  # cart
  end
  helper_method :current_cart

  def admin_only
    redirect_to store_url unless current_user.try(:admin?)
  end

end
