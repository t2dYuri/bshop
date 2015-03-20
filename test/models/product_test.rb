require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  def setup
    @create_product = Product.new(
      title: 'Product Title',
      description: 'Product description',
      price: 1,
      image_url: 'image.jpg')
  end

  test 'Valid product' do
    assert @create_product.valid?
  end

  test 'Creating product with blank attributes' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'Product title uniqueness' do
    @create_product.title = products(:bike).title
    assert @create_product.invalid?
    assert_equal ['has already been taken'],
                 @create_product.errors[:title]
  end

  test 'maximum product title length is 50 characters' do
    @create_product.title = 'a' * 51
    assert_not @create_product.valid?
    assert_equal ['is too long (maximum is 50 characters)'],
                 @create_product.errors[:title]
  end

  test 'maximum product description length is 500 characters' do
    @create_product.description = 'a' * 501
    assert_not @create_product.valid?
    assert_equal ['is too long (maximum is 500 characters)'],
                 @create_product.errors[:description]
  end

  test 'product price' do
    product = @create_product

    # negative price
    assert_no_difference 'Product.count' do
      product.price = -1
      product.save
    end
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    # zero price
    assert_no_difference 'Product.count' do
      product.price = 0
      product.save
    end
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    # non-numeric price
    assert_no_difference 'Product.count' do
      product.price = 'one'
      product.save
    end
    assert product.invalid?
    assert_equal ['is not a number'], product.errors[:price]

    # good price
    assert_difference 'Product.count', +1 do
      product.price = 0.02
      product.save
    end
    assert_not product.errors.any?
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
      title: 'Product Title',
      description: 'Product description',
      price: 1,
      image_url: image_url)
  end

  test 'Product image url' do
    good = %w{ image.gif image.jpg image.png ImAgE.jPg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ image.exe image.gif/else image.gif.else }

    good.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} should be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} should be invalid"
    end
  end
end
