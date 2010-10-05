# coding: utf-8
class RenameAndIndexSubdomainsToDomains < ActiveRecord::Migration
  def self.up
    change_table :restaurants do |t|
      t.rename :subdomain, :domain
      t.index :domain, :unique => true
    end
  end

  def self.down
    change_table :restaurants do |t|
      t.remove_index :domain
      t.rename :subdomain, :domain
    end
  end
end
