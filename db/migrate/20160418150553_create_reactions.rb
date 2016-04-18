class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.string :mode
      t.references :user, index: true, foreign_key: true
      t.references :reactable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :reactions, [:user_id, :reactable_id, :reactable_type],
              unique: true
  end
end
