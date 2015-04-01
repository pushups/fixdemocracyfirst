class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :rwu_id
      t.integer :candidate_id
      t.integer :election_id
      t.timestamps null: false
      t.index :rwu_id
      t.index :candidate_id
      t.index :election_id
    end
  end
end
