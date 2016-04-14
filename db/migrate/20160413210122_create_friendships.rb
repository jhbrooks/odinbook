class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :active_friend, index: true
      t.references :passive_friend, index: true

      t.timestamps null: false
    end
    add_index :friendships, [:active_friend_id, :passive_friend_id],
              unique: true
    add_foreign_key :friendships, :users, column: :active_friend_id
    add_foreign_key :friendships, :users, column: :passive_friend_id
  end
end
