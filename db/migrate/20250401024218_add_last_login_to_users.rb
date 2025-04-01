class AddLastLoginToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_login, :datetime
  end
end
