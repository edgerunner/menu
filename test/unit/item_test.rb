# coding: utf-8
require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def new_item(attributes = {})
    attributes[:name]          ||= 'Köfte'
    attributes[:details]       ||= 'Ayran'
    attributes[:price]         ||= '8.99'
    attributes[:active]        ||= true
    attributes[:restaurant_id] ||= restaurants(:foo).id
    item = Item.new(attributes)
    item.valid? # run validations
    item
  end
  
  test "a regular item should be valid" do
    assert new_item.valid?
  end
  
  test "missing required attributes should fail validation" do
    assert new_item(name: '').invalid?
    assert new_item(price: '').invalid?
    assert new_item(restaurant_id: '').invalid?
  end
  
  test "non numeric price should fail validation" do
    assert new_item(price: 'Cabbar').invalid?
  end
  
  test "pseudo numeric price should be corrected" do
    { '25TL'        => "25.0", 
      '$25'         => "25.0", 
      '25 TL'       => "25.0", 
      '$3.50'       => "3.50", 
      '3,50'        => "3.50", 
      "3,50TL"      => "3.50", 
      "tam 40 lira" => "40.0"
    }.each do |given,expected|
      item = new_item(price: given)
      assert item.valid?, "‘#{given}’ fails as a valid price"
      assert_equal BigDecimal.new(expected), item.price, "#{given} should become #{expected} but turns out as #{item.price}"
    end
  end
  
  test "negative price should fail validation" do
    assert new_item(price: -15).invalid?
  end
end
