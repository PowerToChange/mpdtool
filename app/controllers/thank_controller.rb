class ThankController < ApplicationController
  layout "main"
  
  def index
    @title = "Step 5.1: Thank"
    @col_layout = "two_col"
    items_per_page = 15
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :joins => :mpd_contact_actions, :order => process_sort(params[:sort]), :conditions => process_conditions('thankyou_sent = false'), :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mpd_contact_to_complete", :locals => {:event => 'thankyou_sent'}, :layout => false
    end
  end

  def complete
    items_per_page = 15

    if request.post?
      @mpd_contact = MpdContact.find(params[:id])
      @mpd_contact.send_thankyou!(current_event.id)
    else
      redirect_to :action => :index
    end
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), :conditions => process_conditions('thankyou_sent = false'), :joins => :mpd_contact_actions,
                                     :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mpd_contact_to_complete", :locals => {:event => 'thankyou_sent'}, :layout => false
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
