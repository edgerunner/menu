class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :admin?
  
  def admin?
    true
  end
end
