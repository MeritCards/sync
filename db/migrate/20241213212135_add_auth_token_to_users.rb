class AddAuthTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :token, :string
    add_index :users, :token, unique: true
  end
end
