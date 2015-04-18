class SearchController < ApplicationController
  
  def search
    flash[:alert] = "Please enter a candidate or event name" if params[:q].blank?
    @sr = Event.search(params[:q]).to_a
  end
end

