class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :rwu_id
      t.string :title
      t.string :description
      t.integer :venue_id
      t.boolean :public
      t.timestamps null: false
      t.index :rwu_id
      t.index :venue_id
    end
  end
end
