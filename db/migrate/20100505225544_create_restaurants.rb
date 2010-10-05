# coding: utf-8
class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :subdomain
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :name
      t.string :info
      t.timestamps
    end
    
    change_table :items do |t|
      t.string :restaurant_id
    end
  end
  
  def self.down
    change_table :items do |t|
      t.remove :restaurant_id
    end
    
    drop_table :restaurants
  end
end
