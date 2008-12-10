class ThankController < ApplicationController
  layout "main"
  
  def index
    @title = "Step 5.1: Thank"
    @col_layout = "two_col"
    items_per_page = 15
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :joins => :mpd_contact_actions, :order => process_sort(params[:sort]), :conditions => process_conditions, :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mini_contacts_list", :layout => false
    end
  end

  def toggle_show_thank_help
    if request.xml_http_request?
      mpd_user = MpdUser.find(current_mpd_user.id)
      mpd_user.show_thank_help = !mpd_user.show_thank_help
      mpd_user.save
    end
  end
end
