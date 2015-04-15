require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
    @params = { name: 'Example Name', address: 'Example address', email: 'example@mail.com', pay_type: 'Check' }
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test 'should not get new with empty cart' do
    session[:cart_id] = carts(:cart1).id
    get :new
    assert_redirected_to store_path
    assert_not flash.empty?
  end

  test 'should get new with cart' do
    set_cart_session
    get :new
    assert_response :success
  end

  test 'should create order, destroy its cart & empty session' do
    set_cart_session
    assert_difference 'Order.count', +1 do
      assert_difference 'Cart.count', -1 do
        post :create, order: @params
      end
    end
    assert_redirected_to store_path
    assert_not flash.empty?
    assert_equal session[:cart_id], nil
  end

  test 'should show order' do
    get :show, id: @order
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @order
    assert_response :success
  end

  test 'should update order' do
    patch :update, id: @order, order: @params
    assert_redirected_to order_path(assigns(:order))
    assert_not flash.empty?
  end

  test 'should destroy order' do
    assert_difference 'Order.count', -1 do
      delete :destroy, id: @order
    end
    assert_redirected_to orders_path
    assert_not flash.empty?
  end
end
