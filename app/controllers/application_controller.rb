class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  def mongo_client
    MONGO_CLIENT
  end
end
