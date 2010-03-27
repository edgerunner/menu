class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :details
      t.decimal :price
      t.integer :position
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
