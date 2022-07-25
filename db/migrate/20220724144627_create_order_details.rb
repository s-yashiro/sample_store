class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.references :order, foreign_key: true
      t.belongs_to :item, index: { unique: true }, foreign_key: true
      t.bigint :buyer_id, index: true
      t.bigint :seller_id, index: true
      t.timestamps
    end
  end
end
