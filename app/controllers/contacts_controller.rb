class ContactsController < ApplicationController
  skip_before_filter CAS::Filter
  layout "main"

  PAGE_TITLE = "Edit Contact"
  COL_LAYOUT = "two_col"

  def edit
    @title = PAGE_TITLE
    @col_layout = COL_LAYOUT

    session[:return_to] = request.env["HTTP_REFERER"] 

    @mpd_contact = MpdContact.find(params[:id])
  end
  
  def update
    @title = PAGE_TITLE
    @col_layout = COL_LAYOUT

    @mpd_contact = MpdContact.find(params[:id])
    
    if(!params[:mpd_contact].blank?)
      if (!params[:mpd_contact][:gift_amount].blank?)
        params[:mpd_contact][:gift_amount] = params[:mpd_contact][:gift_amount].gsub(',','')
      end
    end
    
    if @mpd_contact.update_attributes(params[:mpd_contact])
      flash[:success] = "<span>" + @mpd_contact.full_name + "</span> was updated successfully."

      redirect_back_or_default :controller => "dashboard",
                               :action => "index"
    else
      render :action => "edit"
    end
  end
  
end
