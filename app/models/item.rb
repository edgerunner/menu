class Item < ActiveRecord::Base
  scope :current, where("active = ?", true)
  
  
end
