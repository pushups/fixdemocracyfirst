class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.integer :rwu_id
      t.string :name
      t.string :state
      t.string :office_type_id
      t.boolean :special
      t.integer :election_year
      t.timestamps null: false
      t.index :rwu_id
    end
  end
end
