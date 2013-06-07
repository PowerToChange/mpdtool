class DashboardController < ApplicationController
  layout 'main'
  
  # Application default action - displays progress stats and full contact list
  def index
    if current_mpd_user.show_welcome
      redirect_to :action => "welcome"
    else
      @title = "My Ministry Partner Contact Info"
      @col_layout = "two_col"
      conditions =[]
      if params[:sort].nil?
        @show = params[:show] 
      else 
        @show = process_sort_for_show(params[:sort])
      end

      if params[:type].present?
        if  params[:type] == "contact"
          if params[:compare].present?
            select_conditions = params[:selection] + " " + params[:compare] + " '" + params[:value] + "'"
          else
            select_conditions = params[:selection] + " = '" + params[:value] + "'"
          end
        else 
          select_conditions = "mpd_contact_actions." + params[:selection] + " = '" + params[:value] + "'"
        end
          conditions = process_conditions(select_conditions)
      else 
        conditions = process_conditions
      end
      @mpd_contacts = MpdContact.find(:all, :include => "mpd_priorities", :order => process_sort(params[:sort]),
                                       :conditions => conditions, :joins => :mpd_contact_actions)
      
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
