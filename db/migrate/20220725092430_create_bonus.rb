class CreateBonus < ActiveRecord::Migration[7.0]
  def change
    create_table :bonuses do |t|
      t.integer :bonus_type
      t.integer :amount
      t.integer :reward_type

      t.timestamps
    end
  end
end
