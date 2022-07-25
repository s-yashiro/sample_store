class CreateTradeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :log_type
      t.integer :action
      t.bigint :order_id
      t.bigint :quantity
      t.bigint :total

      t.timestamps
    end
    add_index :trade_logs, [:action, :order_id]
  end
end
