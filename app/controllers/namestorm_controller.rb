class NamestormController < ApplicationController
  skip_before_filter CAS::Filter
  layout "main"
  
  # Redirects upon entrance to controller
  def index
    if current_mpd_user.mpd_contacts.count == 0
      redirect_to(:action  => 'start')
    else
      redirect_to(:action  => 'list')
    end
  end
  
  # Initialize set of contacts for user (default namestorming view)
  def start
    @title = "Step 1: Namestorm"
    @col_layout = "two_col"
    session[:first_time_namestorm] = true
    
    if request.post?
      params[:contacts].each do |csv|
        split_and_add_contacts(csv)
      end

      if current_mpd_user.mpd_contacts.size > 0
        redirect_to(:action => 'list')
      else
        flash[:error] = "Try adding some names this time!"
      end
    end
  end
  
  # Display "quick form" and list
  def list
    @title = "Step 1: Namestorm"
    @col_layout = "two_col"
    @show_teaser = session[:first_time_namestorm]
    session[:first_time_namestorm] = nil
    
    items_per_page = 60
    @chunk_size = items_per_page / 3

    @pages, @contacts = paginate_collection current_mpd_user.mpd_contacts.sort_by { |c| c.created_at }.reverse, :per_page => items_per_page, :page => params[:page]

    if request.xml_http_request?
      render :partial => "contacts_list", :layout => false
    else
      render :action => "list"
    end
  end

  # Add contact
  def add
    if request.post? and !params[:full_name].blank? 
      contact = split_and_add_contacts(params[:full_name])
      list
    elsif !request.post? #don't save on a get
      redirect_to(:action => :list)
    else
      list
    end
  end
  
  private 
  # Split comma-delimited list of contacts into new contacts for user
  def split_and_add_contacts(csv)
    for name in csv.split(/,|;/)
      mp = add_contact(name)
    end
  end

  # Create contact for user
  def add_contact(name)
    mp = MpdContact.create(:full_name => name.strip,
                           :mpd_user_id => current_mpd_user.id)
  end
end
