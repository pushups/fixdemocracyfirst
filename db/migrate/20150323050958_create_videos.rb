class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :candidate_id
      t.string :title, null: false, default: ''
      t.string :url, null: false, default: ''
      t.string :question_text
      t.integer :stars, null: false, default: 0
      t.boolean :approved, null: false, default: false
      t.timestamps null: false
      t.index :user_id
      t.index :event_id
      t.index :candidate_id
    end
  end
end
