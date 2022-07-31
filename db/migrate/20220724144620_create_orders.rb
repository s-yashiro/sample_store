class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.bigint :buyer_id, index: true
      t.timestamps
    end
    add_foreign_key :orders, :users, column: :buyer_id
  end
end
