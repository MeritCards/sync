class CreateArchives < ActiveRecord::Migration[8.0]
  def change
    create_table :archives do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :version_number

      t.timestamps
    end
  end
end
