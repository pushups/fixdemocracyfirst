class StatementsController < ApplicationController
  before_filter :require_admin, except: [:new, :create]
  before_action :set_statement, only: [:show, :edit, :update, :destroy]

  # GET /statements
  # GET /statements.json
  def index
    @statements = Statement.all
  end

  # GET /statements/1
  # GET /statements/1.json
  def show
  end

  # GET /statements/new
  def new
    @s3_direct_post = S3_BUCKET.presigned_post({ key: "uploads/#{SecureRandom.uuid}/${filename}", 
                                                 acl: 'public-read', 
                                                 success_action_status: '201', 
                                                 metadata: { 'original-filename' => '${filename}' } })
    @statement = Statement.new
    @statement.user_id = @current_user.id
  end

  # GET /statements/1/edit
  def edit
  end

  # POST /statements
  # POST /statements.json
  def create
    @statement = Statement.new(statement_params)
    @statement.title = "New #{@statement.url.blank? ? 'Tip' : 'Video'} #{DateTime.now}"
    @statement.ugc_date = !statement_params[:ugc_date].empty? ? DateTime.strptime(statement_params[:ugc_date], '%m/%d/%Y').to_date : nil

    respond_to do |format|
      if @statement.save
        format.html { redirect_to '/', notice: 'Thank you for contributing to Questionr!' }
        format.json { render :show, status: :created, location: @statement }
      else
        format.html { redirect_to '/', alert: 'Sorry, your contribution cannot be processed at this time. Please try again later.' }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statements/1
  # PATCH/PUT /statements/1.json
  def update
    respond_to do |format|
      if @statement.update(statement_params)
        format.html { redirect_to @statement, notice: 'Statement was successfully updated.' }
        format.json { render :show, status: :ok, location: @statement }
      else
        format.html { render :edit }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statements/1
  # DELETE /statements/1.json
  def destroy
    @statement.destroy
    respond_to do |format|
      format.html { redirect_to statements_url, notice: 'Statement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statement
      @statement = Statement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statement_params
      params.require(:statement).permit(:rwu_id, :user_id, :event_day_id, :campaign_id, :candidate_id, :title, :url, :description, :approved, :ugc_candidate_name, :ugc_date, :ugc_event_title, :ugc_event_location, :ugc_notes)
    end
end
