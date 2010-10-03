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
  
  end
end
