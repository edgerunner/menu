class Item < ActiveRecord::Base
  acts_as_list
  
  scope :current, where("active = ?", true)
  
  validates_presence_of :name, :details, :price
  validates_numericality_of :price
end
