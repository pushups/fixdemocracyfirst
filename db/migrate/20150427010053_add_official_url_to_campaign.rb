class AddOfficialUrlToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :official_url, :string
  end
end
