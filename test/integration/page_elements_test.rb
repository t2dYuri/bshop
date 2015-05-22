require 'test_helper'

class PageElementsTest < ActionDispatch::IntegrationTest

  setup do
    get store_url
    @bike = products(:bike)
    @frame = products(:frame)
  end

  test 'rendering templates' do
    assert_template 'store/index'
    assert_template partial: 'layouts/_navbar'
    assert_template partial: 'carts/_cart_modal', count: 0
    assert_template partial: 'carts/_cart', count: 0
    assert_template partial: 'shared/_flash', count: 0
  end

  test 'rendering layout elements without cart' do
    assert_select 'link[rel=?][href=?]', 'shortcut icon', '/assets/favicon.ico'
    assert_select 'span#navbar header.navbar-fixed-top' do
      assert_select 'span.pull-left', "#{ Time.zone.now.strftime('%d.%m.%Y') }"
      assert_select 'div.pan-container' do
        assert_select 'a.nav-but[href=?]', store_path, text: 'Home', count: 1 do
          assert_select 'i.glyphicon-home'
        end
        assert_select 'div.btn-group' do
          assert_select 'a.dropdown-toggle', 'Info' do
            assert_select 'i.glyphicon-info-sign'
            assert_select 'b.caret'
          end
          assert_select 'ul.dropdown-menu' do
            assert_select 'li a[href=?]', '#', text: 'Questions', count: 1
            assert_select 'li a[href=?]', '#', text: 'News', count: 1
            assert_select 'li a[href=?]', '#', text: 'Contact', count: 1
          end
        end
        assert_select 'a.nav-but[href=?]', products_path, text: 'Products', count: 1 do
          assert_select 'i.glyphicon-th-list'
        end
        assert_select 'a.nav-but[href=?]', orders_path, text: 'Orders', count: 1 do
          assert_select 'i.glyphicon-list-alt'
        end
        assert_select 'a.nav-but[href=?]', carts_path, text: 'All Carts', count: 1 do
          assert_select 'i.glyphicon-qrcode'
        end
        assert_select 'a.nav-my-cart i.glyphicon-shopping-cart', count: 0
      end
    end
    assert_select 'span#cart_modal', text: ''
    assert_select "div.container-fluid div.#{ controller.controller_name }"
  end



  test 'rendering cart elements after adding line items' do
    post line_items_path, { product_id: @bike.id }, { HTTP_REFERER: store_url }
    post line_items_path, { product_id: @frame.id }, { HTTP_REFERER: store_url }

    cart = Cart.find(session[:cart_id])
    item_bike =  cart.line_items.find_by(product_id: @bike.id)
    item_frame = cart.line_items.find_by(product_id: @frame.id)

    assert_redirected_to store_url
    follow_redirect!
    assert_template partial: 'carts/_cart_modal', count: 1
    assert_template partial: 'carts/_cart', count: 1
    assert_select 'a.nav-my-cart', text: ' My Cart (2 items)', count: 1 do
      assert_select 'i.glyphicon-shopping-cart', 1
    end
    # Modal start
    assert_select 'span#cart_modal div.modal', 1 do
      assert_select 'a[data-dismiss=modal] i.glyphicon-off'
      assert_select 'h3', 'My Cart'
      assert_select 'div.entry table' do
        assert_select 'tr.line-even' do
          assert_select 'td', '1'
          assert_select 'td', "#{@bike.title}"
          assert_select 'td form.edit_line_item' do
            assert_select 'input.qty-field[value=?]', '1'
            assert_select 'button.glyphicon-refresh'
          end
          assert_select 'td.control-links a.del-but[data-method=delete][href=?]', line_item_path(item_bike)
        end
        assert_select 'tr.line-odd' do
          assert_select 'td', '2'
          assert_select 'a.del-but[data-method=delete][href=?]', line_item_path(item_frame)
        end
        assert_select 'tr.table-total-line td#sum-price',
                      "Total : #{ ActionController::Base.helpers.number_to_currency(cart.total_price) }"
      end
      assert_select 'div.bottom-line' do
        assert_select 'a.btn-main[data-dismiss=modal]', text: 'Hide Cart' do
          assert_select 'i.glyphicon-level-up'
        end
        assert_select 'a.btn-delete[data-method=delete][href=?]', cart_path(cart), text: 'Empty cart' do
          assert_select 'i.glyphicon-remove'
        end
        assert_select 'a.btn-confirm[href=?]', new_order_path, text: 'Make Order' do
          assert_select 'i.glyphicon-ok'
        end
      end
    end # Modal end
  end

  test 'rendering cart elements after adding line item via AJAX' do
    xhr :post, line_items_path, product_id: @bike.id
    assert_response :success
    assert_template partial: 'carts/_cart_modal', count: 1
    assert_template partial: 'carts/_cart', count: 1
    # rendering navbar with elements from previous test via JS
    assert_select_jquery :html, '#navbar' do
      assert_select 'a.nav-my-cart', text: ' My Cart (1 item)'
    end
    # rendering cart modal with elements from previous test via JS
    assert_select_jquery :html, '#cart_modal' do
      assert_select 'div.modal'
    end
  end

  # test 'new order form elements' do
  #
  # end

  # test 'products elements' do
  #
  # end

end
