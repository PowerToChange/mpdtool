require 'fastercsv'
require 'fpdf'
require "htmldoc"

class AddressesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  layout "main", :except => ["export_as_csv", "print_letter", "letter_pdf"]
  
  # Display list of ministry partners
  def index
    @title = "Step 3.1: Gather Addresses"
    @col_layout = "two_col"
    items_per_page = 25
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), :conditions => process_conditions('letter_sent = false'), :joins => :mpd_contact_actions, :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mpd_contact_to_complete", :locals => {:event => 'letter_sent'}, :layout => false
    end
  end

  def complete
    items_per_page = 25

    if request.post?
      @mpd_contacts = current_mpd_user.mpd_contacts.find_all{|contact| contact.mpd_contact_actions.find_by_event_id(current_event).is_selected_letter if contact.mpd_contact_actions.find_by_event_id(current_event)}
      @mpd_contacts.each{|contact| contact.send_letter!(current_event.id); contact.selected!(current_event.id, 'letter') }
    else
      redirect_to :action => :index
      return
    end
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), :conditions => process_conditions('letter_sent = false'), :joins => :mpd_contact_actions,
                                     :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mpd_contact_to_complete", :locals => {:event => 'letter_sent'}, :layout => false
    else
      redirect_to :action => :index
    end
  end 
  
  # Export Ministry Partners as CSV
  def export_as_csv
    contacts = current_mpd_user.mpd_contacts
    csv_setup
    result = FasterCSV.generate do |csv|
      # Write Column Headers
      csv << ["Full Name", "Salutation", "Address 1", "Address 2", "City", "State", "Zip", "Phone", "Email Address", "Gift Amount", "Letter Sent?", "Call Made?", "Thank-you Sent?", "Notes"]
      
      # Write data rows
      contacts.each do |c|
        csv << [c.full_name, c.salutation, c.address_1, c.address_2, c.city, c.state, c.zip, number_to_phone(c.phone, :area_code => true), c.email_address, number_to_currency(number_with_delimiter(c.gift_amount(current_event.id))), c.letter_sent(current_event.id), c.contacted(current_event.id), c.thankyou_sent(current_event.id), c.notes]
      end
    end
    render :text => result
  end
  
  # Render PDF of Address Labels to browser
  def address_labels
    # Send PDF data to browser
    @mpd_contacts = current_mpd_user.mpd_contacts
    if params[:print_selected_labels]
      @mpd_contacts = @mpd_contacts.find_all{|contact| contact.mpd_contact_actions.find_by_event_id(current_event).is_selected_letter if contact.mpd_contact_actions.find_by_event_id(current_event)}
    end
    send_data create_address_labels_pdf(@mpd_contacts), :filename => "address_labels.pdf", :type => "application/pdf" 
  end

  def print_letter
    @mpd_contacts = current_mpd_user.mpd_contacts
    # @mpd_contacts = [current_mpd_user.mpd_contacts.first]
    @letter = MpdLetter.find(:first, :conditions => ["mpd_user_id = ? AND name = ?", current_mpd_user.id, params[:letters]]) #current_mpd_user.mpd_letter
    if @letter
      if params[:print_sent_marked_false]
        @mpd_contacts = @mpd_contacts.find_all {|contact| !contact.mpd_contact_actions.find_by_event_id(current_event).letter_sent if contact.mpd_contact_actions.find_by_event_id(current_event)}
      end
      if params[:print_selected_contacts]
        @mpd_contacts = @mpd_contacts.find_all{|contact| contact.mpd_contact_actions.find_by_event_id(current_event).is_selected_letter if contact.mpd_contact_actions.find_by_event_id(current_event)}
      end
      unless @mpd_contacts.empty?
        letter = render_to_string(:action => "letter_pdf")
        #Replaces elipsis that are in unicode
        while letter.sub!(/(\xE2\x80\xA6)/, "...") 
        end
        #Replaces odd apostrophe like characters with UTF-8 apostrophe
        while letter.sub!(/(\xE2\x80\x9B)|(\xC2\xB4)|(\xE2\x80\x98)|(\xE2\x80\x99)/, "'")
        end
        path = File.join(RAILS_ROOT, "public", "pdfs", current_mpd_user.id.to_s)
        FileUtils.mkpath(path) unless File.exists?(path)
        filename = File.join(path, "mpd_letter.pdf")
        htmldoc_env = "HTMLDOC_NOCGI=TRUE;export HTMLDOC_NOCGI" 
        
        pdf = PDF::HTMLDoc.new
        pdf.set_option :outfile, filename
        pdf.set_option :left, '2cm'
        pdf.set_option :right, '2cm'
        pdf.set_option :webpage, true
        PDF::HTMLDoc.program_path = "#{htmldoc_env};htmldoc"
        # pdf.set_option :titlefile, "MPD Letter"
        pdf.set_option :path, "\".;#{File.join(RAILS_ROOT, "public")}\""
        
        # pdf.header ".t."
        pdf << letter
          
        pdf.footer "..."

        pdf.generate
        unless pdf.errors.length > 0
           logger.debug "Successfully generated a PDF file"
           send_file(filename, :filename => 'Letter.pdf', :type => 'application/pdf')
        else 
          File.unlink(filename)
          raise pdf.errors.inspect if pdf.errors.length > 0
          raise pdf.inspect
        end
        # Mark contacts as letter having been sent
#        action_ids = @mpd_contacts.collect {|contact| contact.action(current_event.id)}.collect(&:id)
#        MpdContactAction.update_all("letter_sent = 1", "id IN (#{action_ids.join(',')})")
      else
        flash[:error] = "You don't have any contacts with valid addresses to send letters to."
        redirect_to(:action => :index)
      end
    else
      flash[:error] = "You must write your letter before you can print it!"
      redirect_to(:action => :index)
    end
  end
  
  def letter_pdf #does this method ever get called?
    @mpd_contacts = current_mpd_user.mpd_contacts
    @letter = MpdLetter.find(:first, :conditions => "mpd_user_id=#{current_mpd_user.id}") #current_mpd_user.mpd_letter
  end
  
  private
  # Create PDF of Address Labels
  def create_address_labels_pdf(contacts)
    top_margin = 0.5                        # Distance of first label from top of page
    right_margin = 0.5                      # Distance of last label from right side of page
    left_margin = 0.1875                    # Distance of first label from left side of page
    
    horizontal_pitch = 2.875                # Distance between left edges of adjacent columns
    vertical_pitch = label_height = 1.05     # Distance between top edges of adjacent rows
    label_width = 2.5935                    # Width of label (in)
    labels_across = 3.0                     # Number of columns
    labels_down = 10.0                      # Number of rows

    # Initialize Page
    pdf=FPDF.new('P','in','letter')         # (orientation, units, page_size)
    pdf.SetFont('Arial','B',8)              # (family, style, size)
    pdf.SetMargins(left_margin, top_margin, right_margin) # (left margin, top margin, right margin)
    pdf.SetAutoPageBreak(false)             # We'll control the page breaks, thank you

    # Add first page
    pdf.AddPage

    #Initialize counters
    current_column = 0
    current_row = 0

    # Write cells
    contacts.each do |c|
      # Calculate x,y coordinates for cell
      cell_left = (current_column * horizontal_pitch) + left_margin
      cell_top = (current_row * vertical_pitch) + top_margin + 0.1
      
      # Navigate to x,y for cell
      pdf.SetXY(cell_left,cell_top)
      
      if !c.address_1.blank?
        # Build string for label
        text = c.full_name + "\n"
        text += c.address_1 + "\n"
        text += c.address_2 + "\n" if !c.address_2.blank?
        text += c.city + ', ' + c.state + ' ' + c.zip

        # Write cell to PDF (this method is buggy)
        pdf.MultiCell(label_width, 0.153, text)

        # Increment counters and add page if end is reached
        if (current_column + 1 != labels_across)  
          current_column += 1
        else 
          current_column = 0
          if (current_row + 1 != labels_down)
            current_row += 1
          else
            current_row = 0
            pdf.AddPage
          end
        end
      end
    end 

    # Return PDF data
    pdf.Output 
  end

  # Write CSV to browser
  def csv_setup
      # Set filename
     filename = "ministry_partners.csv"    

     #this is required if you want this to work with IE        
     if request.env['HTTP_USER_AGENT'] =~ /msie/i
       headers['Pragma'] = 'public'
       headers["Content-type"] = "text/plain" 
       headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
       headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
       headers['Expires'] = "0" 
     else
       headers["Content-Type"] ||= 'text/csv'
       headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
       headers['Cache-Control'] = ''
     end
  end
end
