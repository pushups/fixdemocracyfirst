class AddOfficialUrlToEvent < ActiveRecord::Migration
  def change
    add_column :events, :official_url, :string
  end
end
