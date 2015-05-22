require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  def setup
    @new_order = Order.new(
      name: 'Example Customer',
      email: 'example@mail.com',
      email_confirmation: 'example@mail.com',
      address: 'Example customer address',
      pay_type: 'Check',
      zip_code: '79031',
      country: 'Example country',
      region: 'Example region',
      city: 'Example city',
      phone: '20987654321',
      add_info: 'Example add info')
  end

  test 'valid order' do
    assert_difference 'Order.count', +1 do
      @new_order.save
    end
    assert @new_order.valid?
    assert_not @new_order.errors.any?
  end

  test 'new order with empty params' do
    order = Order.new(name: '', email: '', email_confirmation: '', address: '', pay_type: '',
      zip_code: '', country: '', region: '', city: '', phone: '', add_info: '')
    assert_no_difference 'Order.count' do
      order.save
    end
    assert order.invalid?
    assert order.errors[:name].any?
    assert order.errors[:address].any?
    assert order.errors[:email].any?
    assert order.errors[:email_confirmation].any?
    assert order.errors[:pay_type].any?
    assert order.errors[:city].any?
    assert order.errors[:phone].any?
    assert_not order.errors[:zip_code].any?
    assert_not order.errors[:country].any?
    assert_not order.errors[:region].any?
    assert_not order.errors[:add_info].any?
  end

  test 'order name cannot be too short' do
    assert_no_difference 'Order.count' do
      @new_order.name = 'a' * 4
      @new_order.save
    end
    assert @new_order.errors[:name].any?
  end

  test 'order name cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.name = 'a' * 41
      @new_order.save
    end
    assert @new_order.errors[:name].any?
  end

  test 'order email cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.email = 'a' * 52 + '@mail.com'
      @new_order.email_confirmation = 'a' * 52 + '@mail.com'
      @new_order.save
    end
    assert @new_order.errors[:email].any?
  end

  test 'order with wrong email confirmation' do
    assert_no_difference 'Order.count' do
      @new_order.email_confirmation = 'wrong.confirmation@email.com'
      @new_order.save
    end
    assert @new_order.errors[:email_confirmation].any?
  end

  test 'wrong email should not pass validation' do
    invalid_emails =
      %w[example@mail,com example_mail.com example@mail. example@mailcom example@mail_baz.com]
    invalid_emails.each do |invalid_mail|
      @new_order.email = invalid_mail
      @new_order.email_confirmation = invalid_mail
      assert @new_order.invalid?, "#{invalid_mail.inspect} should be invalid"
      assert @new_order.errors[:email].any?
    end
  end

  test 'good email should pass validation' do
    valid_emails =
      %w[example@mail.com e.x-a_m+ple@mail.org example@ma.il.com]
    valid_emails.each do |valid_mail|
      @new_order.email = valid_mail
      @new_order.email_confirmation = valid_mail
      assert @new_order.valid?, "#{valid_mail.inspect} should be valid"
    end
  end

  test 'order should lower-case email before save' do
    wrong_case_email = 'eXaMpLe@mAiL.Cn'
    assert_difference 'Order.count', +1 do
      @new_order.email = wrong_case_email
      @new_order.email_confirmation = wrong_case_email
      @new_order.save
    end
    assert_equal wrong_case_email.downcase, @new_order.reload.email
  end

  test 'order phone cannot be too short' do
    assert_no_difference 'Order.count' do
      @new_order.phone = '1' * 9
      @new_order.save
    end
    assert @new_order.errors[:phone].any?
  end

  test 'order phone cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.phone = '1' * 16
      @new_order.save
    end
    assert @new_order.errors[:phone].any?
  end

  test 'order phone should be converted into integer' do
    assert_difference 'Order.count', +1 do
      @new_order.phone = '+1 (012) 345-67-89 . word _'
      @new_order.save
    end
    assert_equal '10123456789', @new_order.phone
  end

  test 'order zip code cannot be too short' do
    assert_no_difference 'Order.count' do
      @new_order.zip_code = '1' * 4
      @new_order.save
    end
    assert @new_order.errors[:zip_code].any?
  end

  test 'order zip code cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.zip_code = '1' * 7
      @new_order.save
    end
    assert @new_order.errors[:zip_code].any?
  end

  test 'order zip code should be digital-only' do
    assert_no_difference 'Order.count' do
      @new_order.zip_code = 'a' * 5
      @new_order.save
    end
    assert @new_order.errors[:zip_code].any?
  end

  test 'order country cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.country = 'a' * 61
      @new_order.save
    end
    assert @new_order.errors[:country].any?
  end

  test 'order region cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.region = 'a' * 61
      @new_order.save
    end
    assert @new_order.errors[:region].any?
  end

  test 'order city cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.city = 'a' * 61
      @new_order.save
    end
    assert @new_order.errors[:city].any?
  end

  test 'order address cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.address = 'a' * 501
      @new_order.save
    end
    assert @new_order.errors[:address].any?
  end

  test 'order additional info cannot be too long' do
    assert_no_difference 'Order.count' do
      @new_order.add_info = 'a' * 501
      @new_order.save
    end
    assert @new_order.errors[:add_info].any?
  end

  test 'order pay_type cannot be wrong' do
    assert_no_difference 'Order.count' do
      @new_order.pay_type = 'money'
      @new_order.save
    end
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
