class AddUniqueIndexToPoint < ActiveRecord::Migration[7.0]
  def up
    if index_exists? :points, :user_id, name: "index_points_on_user_id"
      remove_reference :points, :user
      add_reference :points, :user, index: { unique: true }, foreign_key: true
    end
  end
end
