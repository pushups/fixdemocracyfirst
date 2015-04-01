class CreateEventDays < ActiveRecord::Migration
  def change
    create_table :event_days do |t|
      t.integer :rwu_id
      t.integer :event_id
      t.timestamp :date
      t.timestamp :start_time
      t.timestamp :end_time
      t.timestamps null: false
      t.index :rwu_id
      t.index :event_id
    end
  end
end
