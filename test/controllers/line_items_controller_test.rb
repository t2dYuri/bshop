require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
  end

  def set_referer
    request.env['HTTP_REFERER'] = store_url
  end

  test 'should create line_item' do
    set_referer
    assert_difference('LineItem.count') do
      post :create, product_id: products(:bike).id
    end
    # assert_redirected_to cart_path(assigns(:line_item).cart)
    assert_redirected_to store_url
  end

  test 'should create line_item with ajax' do
    assert_difference 'LineItem.count', +1 do
      xhr :post, :create, product_id: products(:bike).id
    end
    assert_response :success
    assert_select_jquery :html, '#navbar' do
      assert_select 'a', /My Cart/
    end
    assert_select_jquery :html, '#cart_modal' do
      assert_select 'td', /Cannondale Trail 5/
    end
  end

  test 'should create line item with default quantity' do
    set_referer
    post :create, product_id: products(:bike).id
    assert_equal 1, @line_item.quantity
  end

  test 'should update line_item' do
    set_cart_session
    set_referer
    patch :update, id: @line_item, line_item: { product_id: @line_item.product_id }
    assert_redirected_to store_url(session[:cart_id])
  end

  test 'should update line_item with ajax' do
    set_cart_session
    xhr :patch, :update, id: @line_item, line_item: { product_id: @line_item.product_id }
    assert_response :success
    assert_select_jquery :html, '#current_cart' do
      assert_select 'h3', 'My Cart'
    end
    assert @current_item = @line_item
  end

  test 'should destroy line item' do
    set_cart_session
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item
    end
    assert_redirected_to Cart.find(session[:cart_id])
    assert flash.empty?
  end

  test 'should destroy last line item and cart' do
    set_cart_session
    delete :destroy, id: @line_item
    assert_difference('Cart.count', -1) do
      delete :destroy, id: line_items(:two)
    end
    # assert_redirected_to carts_path
    assert_response :redirect
    assert_not flash.empty?
  end

  test 'should destroy line item with ajax' do
    set_cart_session
    assert_difference('LineItem.count', -1) do
      xhr :delete, :destroy, id: @line_item
    end
    assert_response :success
    assert_select_jquery :html, '#current_cart'
  end

  test 'should destroy last line item and cart with ajax' do
    set_cart_session
    xhr :delete, :destroy, id: @line_item
    assert_difference('Cart.count', -1) do
      xhr :delete, :destroy, id: line_items(:two)
    end
    assert_response :success
    assert_match /Your cart is empty/, response.body
  end
end
