class SearchController < ApplicationController
  
  def search
    flash[:alert] = "Please enter a candidate or event name" if params[:q].blank?
    @events = Event.search(params[:q]).records.to_a
    @candidates = Candidate.search(params[:q]).records.to_a    
  end
end

