class AddImageUrlToPeople < ActiveRecord::Migration
  def change
    add_column :people, :image_url, :string, :null => true
  end
end
