class AddCustomersTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_token, :string
  end
end
