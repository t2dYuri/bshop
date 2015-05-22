require 'test_helper'

class LineItemsManipulationsTest < ActionDispatch::IntegrationTest

  setup do
    @bike = products(:bike)
  end

  test 'changing product price should not change line item price' do
    # adding product bike to cart
    post line_items_path, { product_id: @bike.id }, { HTTP_REFERER: store_url }
    cart = Cart.find(session[:cart_id])
    item =  cart.line_items.find_by(product_id: @bike.id)
    assert_equal item.price, @bike.price

    # changing price of bike
    patch product_path(@bike), product: { price: 1000 }
    @bike.reload
    assert_not_equal item.price, @bike.price
  end

end
