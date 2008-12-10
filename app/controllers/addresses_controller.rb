require 'fastercsv'
require 'fpdf'
require "htmldoc"
#require 'session'

class AddressesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  layout "main", :except => ["export_as_csv", "print_letter", "letter_pdf"]
  
  # Display list of ministry partners
  def index
    @title = "Step 3.1: Gather Addresses"
    @col_layout = "two_col"
    items_per_page = 15
    
    @pages, @mpd_contacts = paginate :mpd_contacts, :include => "mpd_priorities", :order => process_sort(params[:sort]), :conditions => process_conditions, :joins => :mpd_contact_actions, :per_page => items_per_page  

    if request.xml_http_request?
      render :partial => "shared/mini_contacts_list", :layout => false
    end
  end

  # Export Ministry Partners as CSV
  def export_as_csv
    contacts = current_mpd_user.mpd_contacts
    stream_csv do |csv|
      # Write Column Headers
      csv << ["Full Name", "Address 1", "Address 2", "City", "State", "Zip", "Phone", "Email Address", "Gift Amount", "Letter Sent?", "Call Made?", "Thank-you Sent?", "Notes"]
      
      # Write data rows
      contacts.each do |c|
        csv << [c.full_name, c.address_1, c.address_2, c.city, c.state, c.zip, number_to_phone(c.phone, :area_code => true), c.email_address, number_to_currency(number_with_delimiter(c.gift_amount)), c.letter_sent, c.call_made, c.thankyou_sent, c.notes]
      end
    end
  end
  
  # Render PDF of Address Labels to browser
  def address_labels
    # Send PDF data to browser
    send_data create_address_labels_pdf(current_mpd_user.mpd_contacts), :filename => "address_labels.pdf", :type => "application/pdf" 
  end

  def print_letter
    @mpd_contacts = current_mpd_user.mpd_contacts
    # @mpd_contacts = [current_mpd_user.mpd_contacts.first]
    @letter = current_mpd_user.mpd_letter
    if @letter
      if params[:print_all] == 'false'
        @mpd_contacts = @mpd_contacts.find_all {|contact| !contact.address_1.to_s.blank?}
      end
      unless @mpd_contacts.empty?
        letter = render_to_string(:action => "letter_pdf")
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
           send_file(filename)
        else 
          File.unlink(filename)
          raise pdf.errors.inspect if pdf.errors.length > 0
          raise pdf.inspect
        end
        # Mark contacts as letter having been sent
        action_ids = @mpd_contacts.collect {|contact| contact.action(current_event.id)}.collect(&:id)
        MpdContactAction.update_all("letter_sent = 1", "id IN (#{action_ids.join(',')})")
      else
        flash[:error] = "You don't have any contacts with valid addresses to send letters to."
        redirect_to(:action => :index)
      end
    else
      flash[:error] = "You must write your letter before you can print it!"
      redirect_to(:action => :index)
    end
  end
  
  def letter_pdf
    @mpd_contacts = current_mpd_user.mpd_contacts
    @letter = current_mpd_user.mpd_letter
  end
  
  private
  # Create PDF of Address Labels
  def create_address_labels_pdf(contacts)
    top_margin = 0.5                        # Distance of first label from top of page
    side_margin = 0.125                     # Distance of first label from left side of page
    horizontal_pitch = 2.875                # Distance between left edges of adjacent columns
    vertical_pitch = label_height = 1.035   # Distance between top edges of adjacent rows
    label_width = 2.625                     # Width of label
    labels_across = 3.0                     # Number of columns
    labels_down = 10.0                      # Number of rows

    # Initialize Page
    pdf=FPDF.new('P','in','letter')         # (orientation, units, page_size)
    pdf.SetFont('Arial','B',9.5)            # (family, style, size)
    pdf.SetMargins(side_margin, top_margin)
    pdf.SetAutoPageBreak(false)             # We'll control the page breaks, thank you

    # Add first page
    pdf.AddPage

    #Initialize counters
    current_column = 0
    current_row = 0

    # Write cells
    contacts.each do |c|
      # Calculate x,y coordinates for cell
      cell_left = (current_column * horizontal_pitch) + side_margin
      cell_top = (current_row * vertical_pitch) + top_margin
      
      # Navigate to x,y for cell
      pdf.SetXY(cell_left,cell_top)
      
      if !c.address_1.nil?
        # Build string for label
        text = c.full_name + "\n"
        text += c.address_1 + "\n"
        text += c.address_2 + "\n" if !c.address_2.nil? and !c.address_2.blank?
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
  def stream_csv
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
       end

      render :text => Proc.new { |response, output|
        csv = FasterCSV.new(output, :row_sep => "\r\n") 
      yield csv
    }
  end
end
