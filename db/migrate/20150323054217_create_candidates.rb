class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :campaign_id
      t.string :first
      t.string :last
      t.integer :party, null: false, default: 0
      t.string :district
      t.string :state
      t.timestamps null: false
      t.index :campaign_id
    end
  end
end
