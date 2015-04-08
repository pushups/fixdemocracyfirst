class AddFlagShihTzuToAllTables < ActiveRecord::Migration
  def change
    add_column :venues, :dirty, :integer, null: false, default: 0
    add_column :events, :dirty, :integer, null: false, default: 0
    add_column :event_days, :dirty, :integer, null: false, default: 0
    add_column :attendees, :dirty, :integer, null: false, default: 0
    add_column :campaigns, :dirty, :integer, null: false, default: 0
    add_column :candidates, :dirty, :integer, null: false, default: 0
    add_column :people, :dirty, :integer, null: false, default: 0
    add_column :statements, :dirty, :integer, null: false, default: 0
    add_column :users, :dirty, :integer, null: false, default: 0
    add_column :elections, :dirty, :integer, null: false, default: 0
  end
end