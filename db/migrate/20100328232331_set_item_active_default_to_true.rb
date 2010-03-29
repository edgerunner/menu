class SetItemActiveDefaultToTrue < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.change_default :active, true
    end
  end

  def self.down
    change_table :items do |t|
      t.change_default :active, nil
    end
  end
end
