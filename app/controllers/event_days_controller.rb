class EventDaysController < ApplicationController
  before_filter :require_admin, except: [:index, :show]
  before_action :set_event_day, only: [:show, :edit, :update, :destroy]

  # GET /event_days
  # GET /event_days.json
  def index
    @event_days = EventDay.all
  end

  # GET /event_days/1
  # GET /event_days/1.json
  def show
  end

  # GET /event_days/new
  def new
    @event_day = EventDay.new
  end

  # GET /event_days/1/edit
  def edit
  end

  # POST /event_days
  # POST /event_days.json
  def create
    @event_day = EventDay.new(event_day_params)
    @event_day.date = event_day_params[:date] ? DateTime.strptime(event_day_params[:date], '%m/%d/%Y').to_date : nil

    respond_to do |format|
      if @event_day.save
        format.html { redirect_to @event_day, notice: 'Event day was successfully created.' }
        format.json { render :show, status: :created, location: @event_day }
      else
        format.html { render :new }
        format.json { render json: @event_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_days/1
  # PATCH/PUT /event_days/1.json
  def update
    respond_to do |format|
      #this is a little kludgy, but i couldn't figure out how to hack event_day_params w/o cloning it
      if event_day_params[:date]
        p = event_day_params.clone
        #parse and reformat the date to remove timezone and put in a good format for the db
        p[:date] = DateTime.strptime(event_day_params[:date], '%m/%d/%Y').utc.strftime
        
        #similarly, parse and reformat the start and end times, combining them with the event day's date
        [:start_time, :end_time].each do |t| 
          if event_day_params[t]
            p[t] = DateTime.strptime("#{event_day_params[:date]} #{event_day_params[t]} #{timezone_abbr}", "%m/%d/%Y %H:%M %p %Z")
          end
        end
      end
      
      if @event_day.update(p)
        format.html { redirect_to @event_day, notice: 'Event day was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_day }
      else
        format.html { render :edit }
        format.json { render json: @event_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_days/1
  # DELETE /event_days/1.json
  def destroy
    @event_day.destroy
    respond_to do |format|
      format.html { redirect_to event_days_url, notice: 'Event day was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_day
      @event_day = EventDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_day_params
      params.require(:event_day).permit(:rwu_id, :event_id, :date, :start_time, :end_time)
    end
end
