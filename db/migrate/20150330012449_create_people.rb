class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :rwu_id
      t.string :first_name
      t.string :nickname
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.timestamps null: false
      t.index :rwu_id
    end
  end
end
