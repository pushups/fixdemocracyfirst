class AddFacebookFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, :null => true, :default => ""
    add_column :users, :provider, :string, :null => true, :default => ""
    add_column :users, :gender, :string, :null => true, :default => ""
    add_column :users, :utc_offset, :string, :null => true, :default => ""
    add_column :users, :url, :string, :null => true, :default => ""
    add_column :users, :photo, :string, :null => true, :default => ""
  end
end
