class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.text :location_text
      t.string :location_coords
      t.timestamps null: false
    end
  end
end
