class EventsController < ApplicationController
  layout 'main'
  before_filter :get_event, :only => [:edit, :update, :destroy]
  
  def new
    @event = MpdEvent.new
  end
  
  def create
    @event = current_mpd_user.mpd_events.new(params[:mpd_event])
    if @event.save
      session[:event_id] = @event.id
      flash[:success] = "You have successfully created a new event"
      redirect_to '/'
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    if @event.update_attributes(params[:mpd_event])
      redirect_to '/'
    else
      render :action => :edit
    end
  end
  
  def destroy
    @event.destroy
    session[:event_id] = current_mpd_user.mpd_events.first.id
    redirect_to '/'
  end
  
  protected
  def get_event
    @event = current_mpd_user.mpd_events.find(params[:id])
  end
end
