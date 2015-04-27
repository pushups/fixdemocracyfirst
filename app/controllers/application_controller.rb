class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_current_user
  before_filter :set_default_statement
    
  def set_current_user
    #try to get the user from the rails session
    return @current_user if @current_user
    
    #if that fails, try to get the user_id from a cookie
    user_id = cookies[:current_user_id]
    
    #try to find the user
    if user_id
      begin
        @current_user = User.find(user_id)
        return @current_user
      rescue Exception => e
        #user not found shouldn't mask other possible errors
        raise e unless e.is_a? ActiveRecord::RecordNotFound
      end
    end
    
    #if the user_id wasn't cookied or the cookied user_id wasn't found, 
    #we'll end up here, so create a new "guest" user and cookie its id
    reset_current_user(User.create)
  end
  
  def set_default_statement
    @default_statement ||= Statement.new(:user => @current_user)
  end
  
  def reset_current_user(user)
    @current_user = user
    cookies[:current_user_id] = { value: @current_user.id, :expires => Time.now + 365 * 24 * 60 * 60 }
    @current_user
  end
  
  def require_admin
    redirect_to '/' unless @current_user.admin?
  end
end
