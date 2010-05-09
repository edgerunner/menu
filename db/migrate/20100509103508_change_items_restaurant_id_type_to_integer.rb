class ChangeItemsRestaurantIdTypeToInteger < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.change :restaurant_id, :integer
    end
  end

  def self.down
    change_table :items do |t|
      t.change :restaurant_id, :string
    end
  end
end
