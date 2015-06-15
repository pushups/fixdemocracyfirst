class UsersController < ApplicationController
  before_filter :require_admin, except: [:create, :social_auth]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:social_auth]
  
  def social_auth
    http = Net::HTTP.new Rails.application.config.janrain_api_url.host,
                         Rails.application.config.janrain_api_url.port
    http.use_ssl = true    
    resp = http.post Rails.application.config.janrain_api_url.path,
                     { token: params[:token],
                       format: 'json',
                       apiKey: Rails.application.config.janrain_api_key }.map { |k,v| 
                         "#{CGI::escape k.to_s}=#{CGI::escape v.to_s}" }.join('&')    
    if resp.code == '200'
      @current_user = reset_current_user(User.social_refresh(JSON.parse(resp.body)['profile'].with_indifferent_access))
    else
      logger.fatal ap(@current_user)
      logger.fatal ap(resp)
      raise "social auth failed"
    end
    redirect_to '/', alert: @current_user.admin? ? nil : 'Please contact info@questionr.org to request administrative access.'
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.named
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, 
                                   :last_name, 
                                   :email, 
                                   :location, 
                                   :fb_uid, 
                                   :fb_token, 
                                   :admin, 
                                   :postal_code, 
                                   :latitude, 
                                   :longitude, 
                                   :name, 
                                   :provider, 
                                   :gender, 
                                   :utc_offset, 
                                   :url, 
                                   :photo,
                                   :mobile_phone)
    end
end
