class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.integer :rwu_id
      t.string :name
      t.string :street_address1
      t.string :street_address2
      t.string :unit
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :url
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
      t.index :rwu_id
    end
  end
end
