class AdditionalAttrsToUsers < ActiveRecord::Migration
  def change
    add_index  :users, :email, unique: true
    add_column :users, :password_digest, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :zip_code, :string
    add_column :users, :country, :string
    add_column :users, :region, :string
    add_column :users, :city, :string
    add_column :users, :phone, :string
  end
end
