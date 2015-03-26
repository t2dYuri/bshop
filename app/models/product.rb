class Product < ActiveRecord::Base

  validates :title, :description, :image_url, presence: true
  validates :title, length: { maximum: 50 }, uniqueness: true
  validates :description, length: { maximum: 500 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :image_url, allow_blank: true, format: { with: %r{\.(gif|jpg|png)\Z}i,
                        message: 'must be a URL for GIF, JPG or PNG image.' }

  def self.latest
    Product.order(:updated_at).last
  end
end
