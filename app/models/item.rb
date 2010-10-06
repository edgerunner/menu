# coding: utf-8
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
  
  def name= raw_name
    return if raw_name.blank?
    write_attribute :name, titleize_tr(raw_name)
  end
  def details= raw_details
    return if raw_details.blank?
    write_attribute :details, titleize_tr(raw_details)
  end
  
  private
  
  def titleize_tr string
    up="ABCÇDEFGĞHIİJLKMNOÖPQRSŞTUÜVWXYZ"
    dn="abcçdefgğhıijlkmnoöpqrsştuüvwxyz"
    string.gsub(/[ABCÇDEFGĞHIİJLKMNOÖPQRSŞTUÜVWXYZ]+/) { |w| w[0] + w[1..-1].tr(up, dn)}
  end
end
