require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  def setup
    @line_item = line_items(:one)
    @new_item = LineItem.new( product: products(:bike), cart: carts(:one))
  end

  test 'creating valid line item with default quantity' do
    assert_difference 'LineItem.count', +1 do
      @new_item.save
    end
    assert @new_item.valid?
    assert_equal 1, @new_item.quantity
  end

  test 'line item quantity' do

    # nil quantity
    assert_no_difference 'LineItem.count' do
      @new_item.quantity = nil
      @new_item.save
    end
    assert @new_item.invalid?
    assert @new_item.errors[:quantity].any?

    # negative quantity
    assert_no_difference 'LineItem.count' do
      @new_item.quantity = -1
      @new_item.save
    end
    assert @new_item.invalid?
    assert @new_item.errors[:quantity].any?

    # zero quantity
    assert_no_difference 'LineItem.count' do
      @new_item.quantity = 0
      @new_item.save
    end
    assert @new_item.invalid?
    assert @new_item.errors[:quantity].any?

    # good quantity
    assert_difference 'LineItem.count', +1 do
      @new_item.quantity = 50
      @new_item.save
    end
    assert @new_item.valid?
    assert_not @new_item.errors.any?
    assert_equal 50, @new_item.quantity

    # quantity become integer
    @new_item.quantity = 3.9
    assert @new_item.valid?
    assert_equal 3, @new_item.quantity
  end

  test 'line item should contain product id' do
    assert_no_difference 'LineItem.count' do
      @new_item.product_id = nil
      @new_item.save
    end
    assert @new_item.invalid?
  end
end
