require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  def setup
    @new_order = Order.new(
      name: 'Example Customer',
      email: 'example@mail.com',
      address: 'Example customer address',
      pay_type: 'Check')
  end

  test 'valid order' do
    assert_difference 'Order.count', +1 do
      @new_order.save
    end
    assert @new_order.valid?
    assert_not @new_order.errors.any?
  end

  test 'order params cannot be nil' do
    order = Order.new
    assert_no_difference 'Order.count' do
      order.save
    end
    assert order.invalid?
    assert order.errors[:name].any?
    assert order.errors[:address].any?
    assert order.errors[:email].any?
    assert order.errors[:pay_type].any?
  end

  test 'order name cannot be too short' do
    assert_no_difference 'Order.count' do
      @new_order.name = 'a' * 4
      @new_order.save
    end
    assert @new_order.invalid?
    assert @new_order.errors[:name].any?
  end

  test 'order name cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.name = 'a' * 41
      @new_order.save
    end
    assert @new_order.invalid?
    assert @new_order.errors[:name].any?
  end

  test 'order address cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.address = 'a' * 501
      @new_order.save
    end
    assert @new_order.invalid?
    assert @new_order.errors[:address].any?
  end

  test 'order email cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.email = 'a' * 52 + '@mail.com'
      @new_order.save
    end
    assert @new_order.invalid?
    assert @new_order.errors[:email].any?
  end

  test 'wrong email should not pass validation' do
    invalid_emails =
      %w[example@mail,com example_mail.com example@mail. example@mailcom example@mail_baz.com]
    invalid_emails.each do |invalid_mail|
      @new_order.email = invalid_mail
      assert @new_order.invalid?, "#{invalid_mail.inspect} should be invalid"
      assert @new_order.errors[:email].any?
    end
  end

  test 'good email should pass validation' do
    valid_emails =
      %w[example@mail.com e.x-a_m+ple@mail.org example@ma.il.com]
    valid_emails.each do |valid_mail|
      @new_order.email = valid_mail
      assert @new_order.valid?, "#{valid_mail.inspect} should be valid"
    end
  end

  test 'order should be saved with lower-cased email' do
    wrong_case_email = 'eXaMpLe@mAiL.Cn'
    assert_difference 'Order.count', +1 do
      @new_order.email = wrong_case_email
      @new_order.save
    end
    assert_equal wrong_case_email.downcase, @new_order.reload.email
  end

  test 'order pay_type cannot be wrong' do
    assert_no_difference 'Order.count' do
      @new_order.pay_type = 'money'
      @new_order.save
    end
    assert @new_order.invalid?
    assert @new_order.errors[:pay_type].any?
  end

  test 'all valid pay types should pass validation' do
    valid_pay_types = ['Check', 'Credit card', 'Purchse order', 'PayPal']
    valid_pay_types.each do |valid_pay_type|
      @new_order.pay_type = valid_pay_type
      assert @new_order.valid?, "#{valid_pay_type.inspect} should be valid"
    end
  end

  test 'deleting order and all its line items' do
    @new_order.add_cart_line_items(carts(:one))
    @new_order.save
    assert_difference 'Order.count', -1 do
      assert_difference 'LineItem.count', -2 do
        @new_order.destroy
      end
    end
  end
end
