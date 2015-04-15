class Order < ActiveRecord::Base

  has_many :line_items, dependent: :destroy

  before_save   :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PAYMENT_TYPES = ['Check', 'Credit card', 'Purchse order', 'PayPal']

  validates :name, length: { in: 5..40 }
  validates :address, presence: true, length: { maximum: 500 }
  validates :email,   presence: true, length: { maximum: 60 },
            format: { with: VALID_EMAIL_REGEX }, case_sensitive: false
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_cart_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
