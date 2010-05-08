class Restaurant < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :domain, :email, :password, :password_confirmation, :name, :info
  
  attr_accessor :password
  before_save :prepare_password
  
  validates_presence_of :domain, :name
  validates_uniqueness_of :domain
  validates_format_of :domain, :with => /^[a-z][a-z0-9-]+(\.[a-z][a-z0-9-]+)+$/i
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
  
end
