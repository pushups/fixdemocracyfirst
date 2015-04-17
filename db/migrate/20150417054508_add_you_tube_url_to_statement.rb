class AddYouTubeUrlToStatement < ActiveRecord::Migration
  def change
    add_column :statements, :youtube_url, :string, null: true
  end
end
