class EventsController < ApplicationController
  before_filter :require_admin, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
    
  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @videos = @event.statements
    @attendee = Attendee.new
    @attendee.user = @current_user
    @attendee.event_day = @event.event_days.first
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if params[:commit] == '+'
        process_method_and_redirect(format,
                                    :candidates, 
                                    :add_candidate, 
                                    event_params[:candidates],
                                    'added') if !event_params[:candidates].blank?
        process_method_and_redirect(format,
                                    :speaker, 
                                    :add_person, 
                                    event_params[:people],
                                    'added') if !event_params[:people].blank?
      elsif params[:commit] == 'X'
        process_method_and_redirect(format,
                                    :candidates, 
                                    :remove_candidate, 
                                    params[:candidate_id_to_remove],
                                    'removed') if !params[:candidate_id_to_remove].blank?
        process_method_and_redirect(format,
                                    :speaker, 
                                    :remove_person, 
                                    params[:person_id_to_remove],
                                    'removed') if !params[:person_id_to_remove].blank?
      else      
        if @event.update(event_params)
          format.html { redirect_to @event, notice: 'Event was successfully updated.' }
          format.json { render :show, status: :ok, location: @event }
        else
          format.html { render :edit }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:rwu_id, :title, :description, 
        :venue_id, :public, :candidates, :candidate_id_to_remove, 
        :people, :person_id_to_remove, :official_url)
    end

    def process_method_and_redirect(format, symbol, method, id, what_happened)
      @event.send method, id   
      format.html { redirect_to @event, notice: "#{symbol.to_s.titlecase} #{what_happened}." }
      format.json { render :show, status: :ok, location: @event }
    end
end
