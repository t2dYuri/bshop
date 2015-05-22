class AddParamsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :zip_code, :string
    add_column :orders, :country, :string
    add_column :orders, :region, :string
    add_column :orders, :city, :string
    add_column :orders, :phone, :string
    add_column :orders, :add_info, :text
  end
end
