class User < ActiveRecord::Base

  default_scope -> { order(created_at: :asc) }
  attr_accessor :remember_token

  before_save :downcase_email, :nil_if_blank
  # before_validation :strip_phone

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name,     length: { in: 5..40 }
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :phone,    length: { in: 10..15 }, numericality: { only_integer: true }, allow_blank: true
  validates :zip_code, length: { in: 5..6 }, numericality: { only_integer: true }, allow_blank: true
  validates :country,  length: { maximum: 60 }
  validates :region,   length: { maximum: 60 }
  validates :city,     length: { maximum: 60 }
  validates :address,  length: { maximum: 500 }
  validates :email, presence: true, length: { maximum: 60 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  # def strip_phone
  #   self.phone.gsub!(/[^0-9]/, '')
  # end

  def nil_if_blank
    self.class.columns.select { |c| [:text, :string].include?(c.type) }.each do |column|
      send("#{column.name}=", nil) if read_attribute(column.name).blank?
    end
  end
end
