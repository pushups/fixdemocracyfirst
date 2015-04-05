class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_user
  
  def set_user
    #try to get the user from the rails session
    return @user if @user
    
    #if that fails, try to get the user_id from a cookie
    user_id = cookies[:user_id]
    
    logger.debug "COOKIE = #{cookies[:user_id]}"

    #try to find the user
    if user_id
      begin
        @user = User.find(user_id)
        return @user
      rescue Exception => e
        #user not found shouldn't mask other possible errors
        raise e unless e.is_a? ActiveRecord::RecordNotFound
      end
    end
    
    #if the user_id wasn't cookied or the cookied user_id wasn't found, 
    #we'll end up here, so create a new "guest" user and cookie its id
    @user = User.create
    cookies[:user_id] = { value: @user.id, :expires => Time.now + 365 * 24 * 60 * 60 }
    @user
  end
end
