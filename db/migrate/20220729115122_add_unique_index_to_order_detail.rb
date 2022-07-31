class AddUniqueIndexToOrderDetail < ActiveRecord::Migration[7.0]
  def change
    add_index :order_details, [:item_id, :buyer_id, :seller_id], unique: true
  end
end
