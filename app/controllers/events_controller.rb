class EventsController < ApplicationController
  layout 'main'
  before_filter :get_event
  
  def edit
  end
  
  def update
    if @event.update_attributes(params[:mpd_event])
      redirect_to '/'
    else
      render :action => :edit
    end
  end
  
  protected
  def get_event
    @event = MpdEvent.find(params[:id])
  end
end
