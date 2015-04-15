require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @cart = carts(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:carts)
  end

  test 'should show current cart' do
    set_cart_session
    get :show, id: @cart
    assert_response :success
  end

  test 'should not show other cart' do
    session[:cart_id] = carts(:two).id
    get :show, id: @cart
    assert_response :redirect
    assert_not flash.empty?
  end

  # test "should not destroy other cart" do
  #   assert_no_difference('Cart.count') do
  #     delete :destroy, id: @cart
  #   end
  # end

  test 'should destroy own cart' do
    request.env['HTTP_REFERER'] = store_url
    assert_difference('Cart.count', -1) do
      set_cart_session
      delete :destroy, id: @cart
    end
    assert_redirected_to store_url
  end
end
