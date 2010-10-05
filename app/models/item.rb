class Item < ActiveRecord::Base
  belongs_to :restaurant
  acts_as_list :scope => :restaurant
  
  default_scope order('position')
  scope :active, where("active = ?", true)
  scope :fresh, where("updated_at > ?", 1.day.ago)
  
  validates_presence_of :name, :price, :restaurant_id
  validates_associated :restaurant, :on => :create
  validates_numericality_of :price, :greater_than => 0
  
  
  def price= raw_value
    match = raw_value.to_s.match(/-?\d+([.,]\d+)?/)
    return raw_value unless match
    corrected_value = match.to_s.sub(',','.').to_d
    write_attribute :price, corrected_value
  end
end
