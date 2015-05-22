require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  include ActionView::Helpers::NumberHelper

  setup do
    @order = orders(:one)
  end

  test 'received order' do
    mail = OrderNotifier.received(@order)
    assert_equal 'BShop Order Confirmed', mail.subject
    assert_equal ['example@mail.com'], mail.to
    assert_equal ['bshop@example.com'], mail.from
    assert_match "#{ @order.id }", mail.body.encoded
    assert_match @order.name, mail.body.encoded
    assert_match (@order.created_at.strftime '%Y.%m.%d - %H:%M:%S'), mail.body.encoded
    assert_match (number_to_phone @order.phone, area_code: true), mail.body.encoded
    assert_match @order.zip_code, mail.body.encoded
    assert_match @order.country, mail.body.encoded
    assert_match @order.region, mail.body.encoded
    assert_match @order.city, mail.body.encoded
    assert_match @order.address.html_safe, mail.body.encoded
    assert_match @order.add_info.html_safe, mail.body.encoded
    assert_match @order.pay_type, mail.body.encoded
    assert_match /<table style="width: 100%">/, mail.body.encoded
    @order.line_items.each do |item|
      assert_match "#{ item.quantity }", mail.body.encoded
      assert_match (number_to_currency item.price), mail.body.encoded
      assert_match item.product.title, mail.body.encoded
      assert_match (number_to_currency item.total_price), mail.body.encoded
    end
    assert_match (number_to_currency @order.line_items.map(&:total_price).sum), mail.body.encoded
  end

  test 'shipped order' do
    mail = OrderNotifier.shipped(@order)
    assert_equal 'BShop Order Shipped', mail.subject
    assert_equal ['example@mail.com'], mail.to
    assert_equal ['bshop@example.com'], mail.from
    assert_match "#{ @order.id }", mail.body.encoded
    assert_match @order.name, mail.body.encoded
    assert_match @order.zip_code, mail.body.encoded
    assert_match @order.country, mail.body.encoded
    assert_match @order.region, mail.body.encoded
    assert_match @order.city, mail.body.encoded
    assert_match @order.address.html_safe, mail.body.encoded
    assert_match /<table style="width: 100%">/, mail.body.encoded
    @order.line_items.each do |item|
      assert_match "#{ item.quantity }", mail.body.encoded
      assert_match (number_to_currency item.price), mail.body.encoded
      assert_match item.product.title, mail.body.encoded
      assert_match (number_to_currency item.total_price), mail.body.encoded
    end
    assert_match (number_to_currency @order.line_items.map(&:total_price).sum), mail.body.encoded
  end

end
