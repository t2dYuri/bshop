class Order < ActiveRecord::Base

  has_many :line_items, dependent: :destroy

  before_save   :downcase_email
  before_validation :strip_phone

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PAYMENT_TYPES = ['Check', 'Credit card', 'Purchse order', 'PayPal']

  validates :name,     length: { in: 5..40 }
  validates :email,    presence: true, length: { maximum: 60 },
            format: { with: VALID_EMAIL_REGEX }, case_sensitive: false, confirmation: true
  validates :email_confirmation, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES
  validates :phone,    length: { in: 10..15 }, numericality: { only_integer: true }
  validates :zip_code, length: { in: 5..6 }, numericality: { only_integer: true }, allow_blank: true
  validates :country,  length: { maximum: 60 }
  validates :region,   length: { maximum: 60 }
  validates :city,     presence: true, length: { maximum: 60 }
  validates :address,  presence: true, length: { maximum: 500 }
  validates :add_info, length: { maximum: 500 }

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

  def strip_phone
    self.phone.gsub!(/[^0-9]/, '')
  end
end
