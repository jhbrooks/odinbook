class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :city
      t.string :state
      t.string :country
      t.string :time_zone
      t.date :birthday
      t.string :gender
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
