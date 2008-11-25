class DashboardController < ApplicationController
  skip_before_filter CAS::Filter
  layout 'main'
  
  # Application default action - displays progress stats and full contact list
  def index
    if current_mpd_user.show_welcome
      redirect_to :action => "welcome"
    else
      @title = "Your Ministry Dashboard"
      @col_layout = "two_col"
      items_per_page = 15
      
      @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), :conditions => process_conditions, :per_page => items_per_page
  
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
    redirect_to :action => "index"
  end
end
