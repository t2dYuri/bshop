require 'test_helper'

class ProductCartOrderCycleTest < ActionDispatch::IntegrationTest

  test 'Customer buying bike' do
    bike = products(:bike)

    # entering store
    get store_path

    # adding bike to cart via AJAX
    xml_http_request :post, line_items_path, product_id: bike.id
    assert_response :success

    # checking cart
    cart = Cart.find(session[:cart_id])
    assert cart.line_items.count == 1
    assert_equal bike, cart.line_items[0].product

    # creating new order
    get new_order_path
    assert_response :success
    assert_template 'orders/new'

    # saving order with customer's attributes
    post_via_redirect orders_path,
                      order: { name: 'Customer Name',
                               address: 'Customers address',
                               email: 'customer@mail.com',
                               email_confirmation: 'customer@mail.com',
                               pay_type: 'Credit card',
                               zip_code: '79031',
                               country: 'Customer country',
                               region: 'Customer region',
                               city: 'Customer city',
                               phone: '+1 (098) 765-43-21',
                               add_info: 'Customer add info' }
    assert_response :success

    # redirecting to store, reseting session and showing message
    assert_template 'store/index'
    assert_not session[:cart_id].present?
    assert_not flash.empty?

    # checking order
    order = Order.last
    assert_equal 'Customer Name',     order.name
    assert_equal 'Customers address', order.address
    assert_equal 'customer@mail.com', order.email
    assert_equal 'Credit card',       order.pay_type
    assert_equal '79031',             order.zip_code
    assert_equal 'Customer country',  order.country
    assert_equal 'Customer region',   order.region
    assert_equal 'Customer city',     order.city
    assert_equal '10987654321',       order.phone
    assert_equal 'Customer add info', order.add_info
    assert order.line_items.count == 1
    item = order.line_items[0]
    assert_equal bike, item.product

    # checking phone number conversion in order view
    get order_path(order)
    assert_match '1(098) 765-4321', response.body

    # checking email
    mail = ActionMailer::Base.deliveries.last
    assert_equal ['customer@mail.com'], mail.to
    assert_equal 'BShop <bshop@example.com>', mail[:from].value
    assert_equal 'BShop Order Confirmed', mail.subject
    assert_match item.product.title, mail.body.encoded
  end

end
