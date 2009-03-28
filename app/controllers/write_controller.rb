class WriteController < ApplicationController
  layout 'main'

  MAX_FIELD_LENGTH = 1000

  def index
    if current_mpd_user.show_calculator && MpdExpenseType.count > 0
      redirect_to(:action => 'calculate_support_total')
    elsif current_mpd_user.mpd_letter.nil?
      redirect_to(:action => 'select_template')
    else
      letter
      render :action => "letter"
    end
  end
  
  # Select template for letter
  def select_template
    step = MpdExpenseType.count > 0 ? '2.2' : '2.1'
    @title = "Step #{step}: Select a Letter Template"
    @letter_templates = MpdLetterTemplate.find(:all)
    @col_layout = "two_col"
    
    if params[:id]
      template = MpdLetterTemplate.find(params[:id])
      letter = MpdLetter.create(:mpd_letter_template_id => template.id)
      template.number_of_images.times do
        mpd_letter_image = MpdLetterImage.new(:mpd_letter_id => letter.id)
        mpd_letter_image.save(false) #No need for validation checking yet
      end
      
      MpdUser.find(current_mpd_user.id).update_attributes(:mpd_letter_id => letter.id)
      current_mpd_user.reload()
      
      redirect_to(:action => 'index')
    end
  end
  
  # Main form for writing letter
  def letter
    step = MpdExpenseType.count > 0 ? '2.3' : '2.2'
    @title = "Step #{step}: Write Your Letter "
    @col_layout = "two_col"

    @max_field_length = MAX_FIELD_LENGTH    
    @mpd_letter = current_mpd_user.mpd_letter
    @letter_template = @mpd_letter.mpd_letter_template
    @mpd_letter_images = @mpd_letter.mpd_letter_images

   end
  
  # Updates letter from form
  def update_letter
    @title = "Step 2.3: Write Your Letter "
    @col_layout = "two_col"

    if request.post?
      @max_field_length = MAX_FIELD_LENGTH    
      @mpd_letter = MpdLetter.find(params[:mpd_letter][:id])
      @letter_template = @mpd_letter.mpd_letter_template
      @mpd_letter_images = @mpd_letter.mpd_letter_images

      @mpd_letter.attributes = params[:mpd_letter]
      if params[:mpd_letter_image]
        @mpd_letter.mpd_letter_images.each do |i| 
          if params[:mpd_letter_image][i.id.to_s] && !params[:mpd_letter_image][i.id.to_s][:uploaded_data].blank?
            i.attributes =  params[:mpd_letter_image][i.id.to_s]
          end
        end
      end
      
      if @mpd_letter.valid? && @mpd_letter.mpd_letter_images.all?(&:check_valid?)
        @mpd_letter.save!
        @mpd_letter.mpd_letter_images.each do |image|
          image.save! if !image.filename.blank?
        end
        flash['notice'] = 'Your letter was saved successfully.'
        redirect_to :controller => 'addresses'
      else #Reset images if not valid
        @mpd_letter.mpd_letter_images.each do |image|
          image.reload
        end
        render :action =>  :letter
      end
    
#      # Upload images
#      if ((!params[:mpd_letter_image].nil?) and (params[:mpd_letter_image].size > 0))
#        @mpd_letter.mpd_letter_images.each { |i| i.update_attributes(params[:mpd_letter_image][i.id.to_s]) }
#        @mpd_letter.mpd_letter_images.each(&:save!)
#      end
#          
#      # Update letter
#      if @mpd_letter.update_attributes(params[:mpd_letter])
#        flash['notice'] = 'Your letter was saved successfully.'
#        redirect_to :controller => 'addresses'
#      end
    else
      letter
      render :action => :letter
    end
  end
  
  # Calculator for students to determine support total
  def calculate_support_total
    @title = "Step 2.1: Calculate Support Total"
    @col_layout = "two_col"
    
    @user = current_mpd_user
    @event = current_event
    
    if request.post?
      if params[:event]
        # params[:event][:cost] = "0" if params[:event][:cost].blank?
        @event.cost = params[:event][:cost]
      end
      expenses = @event.mpd_expenses
      expenses.each do |e| 
        e.amount = params[:mpd_expense][e.id.to_s][:amount].gsub(',','').to_i 
      end
      @user.show_calculator = false
      begin
        MpdEvent.transaction do
          @user.save!
          @event.save!
          expenses.each(&:save!)
        end
        redirect_to :action => "index"
      rescue ActiveRecord::RecordInvalid
        render
      end
    else
      # Make sure all expenses are tied to an event
      expenses = @user.mpd_expenses.find(:all, :conditions => "mpd_event_id is null")
      expenses.each do |e|
        event = e.mpd_user.mpd_events.first
        e.update_attribute(:mpd_event_id, event.id) if event
      end
    end
  end
end
