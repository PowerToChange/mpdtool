class ContactsController < ApplicationController
  include ActionView::Helpers::NumberHelper
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
  
  def toggle_selected
    
    @mpd_contact = MpdContact.find(params[:id])
    if current_mpd_user.mpd_contacts.include?(@mpd_contact)
      
      @mpd_contact.selected!(current_event.id, params[:context])
    else
      redirect_to :controller => :dashboard
    end
    render :text => ''
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
  
        redirect_to  :controller => "addresses",
                     :action => "index",
                     :page => params[:page]
      else
        render :action => "edit"
      end
    else
      redirect_to :controller => :dashboard
    end
  end
  def update_contact
    mpd_contact = MpdContact.find(params[:id])
    #probably a cleaner way to implement this, works for now...
    mpd_contact.action(current_event.id).update_attribute(:letter_sent, params[:letter_sent]) if params[:letter_sent].present?
    mpd_contact.action(current_event.id).update_attribute(:contacted, params[:contacted]) if params[:contacted].present?
    mpd_contact.action(current_event.id).update_attribute(:thankyou_sent, params[:thankyou_sent]) if params[:thankyou_sent].present?
    mpd_contact.action(current_event.id).update_attribute(:postproject_sent, params[:postproject_sent]) if params[:postproject_sent].present?
    mpd_contact.action(current_event.id).update_attribute(:partner_financial, params[:partner_financial]) if params[:partner_financial].present?
    mpd_contact.action(current_event.id).update_attribute(:partner_prayer, params[:partner_prayer]) if params[:partner_prayer].present?
    mpd_contact.action(current_event.id).update_attribute(:gift_pledged, params[:gift_pledged]) if params[:gift_pledged].present?
    mpd_contact.action(current_event.id).update_attribute(:gift_received, params[:gift_received]) if params[:gift_received].present?
    mpd_contact.save
    mpd_contact.reload
    render :nothing => true
  end
  
  def update_contact_full_name
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.full_name = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.full_name? ? mpd_contact.full_name : "&nbsp;"
  end
  
  def get_full_name
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.full_name
  end 
    
  def update_contact_address
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.address_1 = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.address_1? ? mpd_contact.address_1 : "&nbsp;"
  end
  
  def get_contact_address
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.address_1
  end
  
  def update_contact_salutation
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.salutation = params[:value]
    mpd_contact.save
    mpd_contact.reload                                                                            
    render :text =>  mpd_contact.salutation? ? mpd_contact.salutation : "&nbsp;"
  end
  
  def get_contact_salutation
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.salutation
  end
  
  def update_contact_city
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.city = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.city? ? mpd_contact.city : "&nbsp;"
  end
  
  def get_contact_city
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.city
  end
  
  def update_contact_state
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.state = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.state? ? mpd_contact.state : "&nbsp;"
  end
  
  def get_contact_state
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.state
  end

  def update_contact_zip
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.zip = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.zip? ? mpd_contact.zip : "&nbsp;"
  end
  
  def get_contact_zip
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.zip
  end

  def update_contact_phone
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.phone = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.phone? ? mpd_contact.phone : "&nbsp;"
  end
  
  def get_contact_phone
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.phone
  end

  def update_contact_phone_2
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.phone_2 = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.phone_2? ? mpd_contact.phone_2 : "&nbsp;"
  end
  
  def get_contact_phone_2
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.phone_2
  end

  def update_contact_email_address
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.email_address = params[:value]
    mpd_contact.save
    mpd_contact.reload
    render :text => mpd_contact.email_address? ? mpd_contact.email_address : "&nbsp;"
  end
  
  def get_contact_email_address
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.email_address
  end
  
  def update_contact_gift_amount
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.action(current_event.id).update_attribute(:gift_amount, params[:value].gsub(/[$]/,''))
    mpd_contact.save
    mpd_contact.reload                                                                            
    render :text =>  mpd_contact.gift_amount(current_event.id).present? ? number_to_currency(number_with_delimiter(mpd_contact.gift_amount(current_event.id))) : "$0.00"
  end
  
  def get_contact_gift_amount
    mpd_contact = MpdContact.find(params[:id])
    render :text => number_to_currency(number_with_delimiter(mpd_contact.gift_amount(current_event.id)))
  end
   
  def update_contact_form_received
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.action(current_event.id).update_attribute(:form_received, params[:value])
    mpd_contact.save
    mpd_contact.reload                                                                            
    render :text =>  mpd_contact.form_received(current_event.id).present? ? mpd_contact.form_received(current_event.id) : "&nbsp;"
  end
  
  def get_contact_form_received
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.form_received(current_event.id)
  end
  
  def update_contact_date_received
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.action(current_event.id).update_attribute(:date_received, params[:value])
    mpd_contact.save
    mpd_contact.reload                                                                            
    render :text =>  mpd_contact.date_received(current_event.id).present? ? mpd_contact.date_received(current_event.id) : "&nbsp;"
  end
  
  def get_contact_date_received
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.date_received(current_event.id)
  end
  
  def update_contact_relationship
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.relationship = params[:value]
    mpd_contact.save
    mpd_contact.reload                                                                            
    render :text =>  mpd_contact.relationship? ? mpd_contact.relationship : "&nbsp;"
  end
  
  def get_contact_relationship
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.relationship
  end
    
  def update_contact_notes
    mpd_contact = MpdContact.find(params[:id])
    mpd_contact.notes = params[:value]
    mpd_contact.save
    mpd_contact.reload                                                                            
    render :text =>  mpd_contact.notes? ? mpd_contact.notes : "&nbsp;"
  end
  
  def get_contact_notes
    mpd_contact = MpdContact.find(params[:id])
    render :text => mpd_contact.notes
  end
  
end
