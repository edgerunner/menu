class Item < ActiveRecord::Base
  scope :current, where("active = ?", true)
  
  validates_presence_of :name, :details, :price
  validates_numericality_of :price
end
