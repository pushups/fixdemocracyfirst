class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.integer :user_id
      t.integer :event_day_id
      t.timestamps null: false
      t.index [:event_day_id, :user_id]
      t.index [:user_id, :event_day_id]
    end
  end
end
