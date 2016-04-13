class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.references :sender, index: true
      t.references :receiver, index: true

      t.timestamps null: false
    end
    add_index :friend_requests, [:sender_id, :receiver_id], unique: true
    add_foreign_key :friend_requests, :users, column: :sender_id
    add_foreign_key :friend_requests, :users, column: :receiver_id
  end
end
