class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.integer :status
      t.bigint :seller_id, index: true
      t.timestamps
    end
    add_foreign_key :items, :users, column: :seller_id
  end
end
