class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  validates :product_id, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    # product.price * quantity
    price * quantity
  end
end
