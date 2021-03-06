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
      @mpd_contacts = current_mpd_user.mpd_contacts.find_all{|contact| contact.mpd_contact_actions.find_by_event_id(current_event).is_selected_thankyou if contact.mpd_contact_actions.find_by_event_id(current_event)}
      @mpd_contacts.each{|contact| contact.send_thankyou!(current_event.id); contact.selected!(current_event.id, 'thank you') }
    else
      redirect_to :action => :index
      return
    end
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), :conditions => process_conditions('thankyou_sent = false'), :joins => :mpd_contact_actions,
                                     :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mpd_contact_to_complete", :locals => {:event => 'thankyou_sent'}, :layout => false
    else
      redirect_to :action => :index
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
