require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  setup do
    @product = products(:one)
    @params = { title: 'Lorem Ipsum', description: 'Lorem Description', image_url: 'lorem.jpg', price: 19.99 }
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create product' do
    assert_difference('Product.count') do
      post :create, product: @params
    end
    assert_redirected_to product_path(assigns(:product))
    assert_not flash[:success].empty?
  end

  test 'should show product' do
    get :show, id: @product
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @product
    assert_response :success
  end

  test 'should update product' do
    patch :update, id: @product, product: @params
    assert_redirected_to product_path(assigns(:product))
    assert_not flash[:success].empty?
  end

  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end
    assert_redirected_to products_path
    assert_not flash[:notice].empty?
  end

  test 'should not destroy product with active cart' do
    assert_no_difference 'Product.count' do
      delete :destroy, id: products(:bike)
    end
  end
end
