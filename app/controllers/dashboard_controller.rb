class DashboardController < ApplicationController
  layout 'main'
  
  # Application default action - displays progress stats and full contact list
  def index
    if current_mpd_user.show_welcome
      redirect_to :action => "welcome"
    else
      @title = "My Ministry Partner Contact Info"
      @col_layout = "two_col"
      items_per_page = 15
      
      @pages, @mpd_contacts = paginate(:mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), 
                                       :conditions => process_conditions, :joins => :mpd_contact_actions, :per_page => items_per_page)
  
      if request.xml_http_request?
        render :partial => "shared/full_contacts_list", :layout => false
      end
    end
  end
  
  def welcome
    @title = "Congratulations!"
    @col_layout = "two_col"
  end
  
  def get_started
    MpdUser.find(current_mpd_user.id).update_attributes(:show_welcome => false)
    redirect_to :controller => "namestorm", :action => "index" 
  end
  
  def change_event
    if params[:event_id]
      session[:event_id] = params[:event_id]
    end
    respond_to do |wants|
      wants.js do 
        render :update do |page|
          page.redirect_to '/'
        end
      end
    end
    
  end
end
