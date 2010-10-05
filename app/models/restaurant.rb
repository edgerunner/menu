# coding: utf-8
require 'heroku'

class Restaurant < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :domain, :email, :password, :password_confirmation, :name, :info
  attr_readonly :domain
  
  attr_accessor :password
  before_save :prepare_password
  
  if Rails.env.production?
    before_create :register_domain
    before_destroy :unregister_domain
  end
  
  validates_presence_of :domain, :name
  validates_uniqueness_of :domain
  validates_format_of :domain, :with => /^[a-z][a-z0-9-]+(\.[a-z][a-z0-9-]+)+$/i
  validates_exclusion_of :domain, :in => APP_CONFIG[:reserved_domains]
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  has_many :items, :dependent => :destroy
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  
  private
  
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
  
  def register_domain
    Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD']).add_domain('menu', domain)
  rescue RestClient::RequestFailed
    errors.add :domain, :not_yet_routed
    false
  end
  def unregister_domain
    Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD']).remove_domain('menu', domain)
  end
  
end
