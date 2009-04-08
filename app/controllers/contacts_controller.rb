class ContactsController < ApplicationController
  layout "main"

  PAGE_TITLE = "Edit Contact"
  COL_LAYOUT = "two_col"
  
  #We don't use this so redirect to dashboard
  def show
    redirect_to :controller => :dashboard
  end

  def edit
    @title = PAGE_TITLE
    @col_layout = COL_LAYOUT

    session[:return_to] = request.env["HTTP_REFERER"] 

    @mpd_contact = MpdContact.find(params[:id])
    
    #Make sure this contact is for this user
    if current_mpd_user.mpd_contacts.include?(@mpd_contact)
      # If for some reason this contact doesn't have their action fields, create them
      if @mpd_contact.mpd_contact_actions.empty? || !@mpd_contact.action(current_event.id)
        @mpd_contact.mpd_contact_actions.create(:event_id => current_event.id)
      end
    else
      redirect_to :controller => :dashboard
    end
  end
  
  def update
    @title = PAGE_TITLE
    @col_layout = COL_LAYOUT

    @mpd_contact = MpdContact.find(params[:id])
    
    #Make sure this contact is for this user
    if current_mpd_user.mpd_contacts.include?(@mpd_contact)
      if(params[:mpd_contact_action] && params[:mpd_contact_action][:gift_amount])
        params[:mpd_contact_action][:gift_amount] = params[:mpd_contact_action][:gift_amount].gsub(',','').gsub('$','')
      end
      @mpd_contact_action = @mpd_contact.action(current_event.id)
  
      if @mpd_contact.update_attributes(params[:mpd_contact]) && @mpd_contact_action.update_attributes(params[:mpd_contact_action])
        flash[:success] = "<span>" + @mpd_contact.full_name + "</span> was updated successfully."
  
        redirect_back_or_default :controller => "dashboard",
                                 :action => "index"
      else
        render :action => "edit"
      end
    else
      redirect_to :controller => :dashboard
    end
  end
  
end
