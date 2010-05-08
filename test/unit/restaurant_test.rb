require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  def new_restaurant(attributes = {})
    attributes[:username] ||= 'foo'
    attributes[:email] ||= 'foo@example.com'
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
  
  def test_require_username
    assert new_restaurant(:username => '').errors[:username]
  end
  
  def test_require_password
    assert new_restaurant(:password => '').errors[:password]
  end
  
  def test_require_well_formed_email
    assert new_restaurant(:email => 'foo@bar@example.com').errors[:email]
  end
  
  def test_validate_uniqueness_of_email
    new_restaurant(:email => 'bar@example.com').save!
    assert new_restaurant(:email => 'bar@example.com').errors[:email]
  end
  
  def test_validate_uniqueness_of_username
    new_restaurant(:username => 'uniquename').save!
    assert new_restaurant(:username => 'uniquename').errors[:username]
  end
  
  def test_validate_odd_characters_in_username
    assert new_restaurant(:username => 'odd ^&(@)').errors[:username]
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
  
  def test_authenticate_by_username
    Restaurant.delete_all
    restaurant = new_restaurant(:username => 'foobar', :password => 'secret')
    restaurant.save!
    assert_equal restaurant, Restaurant.authenticate('foobar', 'secret')
  end
  
  def test_authenticate_by_email
    Restaurant.delete_all
    restaurant = new_restaurant(:email => 'foo@bar.com', :password => 'secret')
    restaurant.save!
    assert_equal restaurant, Restaurant.authenticate('foo@bar.com', 'secret')
  end
  
  def test_authenticate_bad_username
    assert_nil Restaurant.authenticate('nonexisting', 'secret')
  end
  
  def test_authenticate_bad_password
    Restaurant.delete_all
    new_restaurant(:username => 'foobar', :password => 'secret').save!
    assert_nil Restaurant.authenticate('foobar', 'badpassword')
  end
end
