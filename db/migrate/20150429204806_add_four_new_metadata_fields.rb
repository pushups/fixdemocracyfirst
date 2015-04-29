class AddFourNewMetadataFields < ActiveRecord::Migration
  def change
    add_column :users, :mobile_phone, :string
    add_column :attendees, :notes, :text
    add_column :statements, :third_party_url, :string
    add_column :candidates, :description, :text
  end
end
