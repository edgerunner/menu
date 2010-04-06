class Item < ActiveRecord::Base
  acts_as_list
  
  default_scope order('position')
  scope :current, where("active = ?", true)
  
  validates_presence_of :name, :details, :price
  validates_numericality_of :price
end
