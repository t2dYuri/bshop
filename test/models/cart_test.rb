require 'test_helper'

class CartTest < ActiveSupport::TestCase

  def setup
    @cart = Cart.create
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test 'should create new cart' do
    assert_difference 'Cart.count', +1 do
      Cart.create
    end
    assert @cart.valid?
  end

  test 'should add products to cart' do

    # adding first product to cart
    @cart.add_product(@product1.id, @product1.price).save!
    assert_equal 1, @cart.line_items.count

    # adding second product to cart
    assert_difference '@cart.line_items.count', +1 do
      @cart.add_product(@product2.id, @product2.price).save!
    end

    # adding first product few more times
    assert_no_difference '@cart.line_items.count' do
      3.times { @cart.add_product(@product1.id, @product1.price).save! }
    end
    item = @cart.line_items.find_by_product_id @product1.id
    assert_equal 4, item.quantity
    assert @cart.valid?
  end

  test 'cart total price should be counted OK' do
    3.times { @cart.add_product(@product1.id, @product1.price).save! }
    assert_equal @product1.price * 3, @cart.total_price
  end

  test 'cart should be destroyed' do
    assert_difference 'Cart.count', -1 do
      @cart.destroy
    end
  end

  test 'deleting cart should destroy its line items' do
    @cart.add_product(@product1.id, @product1.price).save!
    assert_difference 'LineItem.count', -1 do
      @cart.destroy
    end
  end
end
