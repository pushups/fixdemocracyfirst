class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.integer :rwu_id
      t.integer :user_id
      t.integer :event_day_id
      t.integer :campaign_id
      t.integer :candidate_id
      t.string :title
      t.string :url
      t.text :description
      t.boolean :approved
      t.string :ugc_candidate_name
      t.timestamp :ugc_date
      t.string :ugc_event_title
      t.string :ugc_event_location
      t.text :ugc_notes
      t.timestamps null: false
      t.index :rwu_id
      t.index :user_id
      t.index :event_day_id
      t.index :campaign_id
      t.index :candidate_id
    end
  end
end
