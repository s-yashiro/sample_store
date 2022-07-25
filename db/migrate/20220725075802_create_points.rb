class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :balance

      t.timestamps
    end
  end
end
