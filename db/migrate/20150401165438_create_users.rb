class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email
      t.string :location
      t.string :fb_uid
      t.string :fb_token
      t.boolean :admin
      t.timestamps null: false
      t.index :fb_uid
    end
  end
end