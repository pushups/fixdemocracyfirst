class AddPartyAndStatusToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :party, :string, null: true
    add_column :candidates, :status, :string, null: true
  end
end