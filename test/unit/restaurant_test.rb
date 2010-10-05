# coding: utf-8
require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  def new_restaurant(attributes = {})
    attributes[:name]     ||= 'Foo Bar'
    attributes[:domain]   ||= 'foo.menu.test'
    attributes[:email]    ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    restaurant = Restaurant.new(attributes)
    restaurant.valid? # run validations
    restaurant
  end
  
  def setup
    Restaurant.delete_all
  end
  
  def test_valid
    assert new_restaurant.valid?
  end
  
  def test_require_password
    assert new_restaurant(:password => '').errors[:password]
  end
  
  def test_require_well_formed_email
    assert new_restaurant(:email => 'foo@bar@example.com').errors[:email]
  end
  
  def test_validate_password_length
    assert new_restaurant(:password => 'bad').errors[:password]
  end
  
  def test_require_matching_password_confirmation
    assert new_restaurant(:password_confirmation => 'nonmatching').errors[:password]
  end
  
  def test_generate_password_hash_and_salt_on_create
    restaurant = new_restaurant
    restaurant.save!
    assert restaurant.password_hash
    assert restaurant.password_salt
  end
end
