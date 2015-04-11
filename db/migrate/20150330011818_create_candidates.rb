class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :rwu_id
      t.integer :person_id
      t.string :office_id
      t.string :position
      t.string :district
      t.timestamps null: false
      t.index :rwu_id
      t.index :person_id
    end
  end
end
