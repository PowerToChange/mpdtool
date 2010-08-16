# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  DEFAULT_SORT = "full_name"
    
  # Performs calculation to determine offset for time remaining progress bar  
  def calc_time_remaining_bar_offset
    bar_width = 230
    percentage = 0
    
    if (!current_event.start_date.nil?)
      start_date = current_mpd_user.app_accepted_date
      project_date = current_event.start_date.to_time
      todays_date = Time.now
      start_date ||= Time.now
      project_date ||= Time.now
      time_left = project_date - todays_date
      total_diff = project_date - start_date
      
      percentage = (time_left.to_f / total_diff.to_f)
    end
  
      bar_offset = bar_width - (percentage * bar_width)
  end
  
  # Calculates gifts given to user
  def calc_support_received
    MpdContactAction.sum(:gift_amount, :conditions => ["mpd_user_id = ? AND event_id = ?", current_mpd_user.id, current_event.id], :joins => :mpd_contact)
  end
  
  # Calculates percentage of goal has been received by user
  def calc_goal_progress_percentage
    total = current_mpd_user.support_total(current_event.id)
    if !total.nil? and total > 0
      percentage = calc_support_received.to_f / total.to_f
    else 
      percentage = 0
    end
  end
  
  # Performs calculation to determine offset for goal progress bar 
  def calc_goal_progress_offset
    bar_width = 230;
        
    bar_offset = bar_width - (calc_goal_progress_percentage * bar_width)
  end

  # Builds pagination links for ajax-driven contact lists
  def pagination_links_remote(paginator)
    page_options = {:window_size => 4}
    pagination_links_each(paginator, page_options) do |n|
      options = {
        :url => {:action => 'index', :params => params.merge({:page => n})},
        :update => 'contacts_list',
        :before => "Element.show('spinner')",
        :success => "Element.hide('spinner')"
      }
      html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
      link_to_remote(n.to_s, options, html_options)
    end
  end

  # Determines class to be used for column heading in ajax-driven contact lists
  def sort_td_class_helper(param)
    result = 'sortup' if params[:sort] == param
    result = 'sortdown' if params[:sort] == param + "_reverse"
    result = 'sortup' if params[:sort].nil? and DEFAULT_SORT == param    
    return result
  end
  
  # Builds remote link for column headings in ajax-driven contact lists
  def sort_link_helper(text, param)
    key = param

    if params[:sort].nil? and param == DEFAULT_SORT
      key = DEFAULT_SORT + "_reverse"
    elsif params[:sort] == param
      key += "_reverse" 
    end
    
    options = {
        :url => {:action => 'index', :params => params.merge({:sort => key, :page => nil})},
        :update => 'contacts_list',
        :before => "Element.show('spinner')",
        :success => "Element.hide('spinner')"
    }
    html_options = {
      :title => "Sort by this field",
      :href => url_for(:action => 'list', :params => params.merge({:sort => key, :page => nil}))
    }
    link_to_remote(text, options, html_options)
  end

  def error_messages_for_multiple_objects(objects, object_name_for_error, options = {})
    options = options.symbolize_keys
    all_errors = ""
    all_errors_count = 0
    objects.each do |object|
      if object && !object.errors.empty?
        object_errors = object.errors.full_messages.collect {
          |msg| content_tag("li", msg)
        }
        all_errors_count += object_errors.size
        all_errors << "#{object_errors}"
      end
    end
  
    if all_errors_count > 0
      tag = content_tag("div",
        content_tag(
          options[:header_tag] || "h2",
          "#{pluralize(all_errors_count, "error")} prohibited this" \
          " #{object_name_for_error.to_s.gsub("_", " ")} from being saved"
        ) +
        content_tag("p", "There were problems with the following fields:") +
        content_tag("ul", all_errors),
          "id" => options[:id] || "errorExplanation",
          "class" => options[:class] || "errorExplanation"
      )
    else
      ""
    end
  end

  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(RAILS_ROOT) + '/public/files/mpd_letter_image/image/' + image 
    tag(:img, options)
  end
  
  def editable_content(options)
   options[:content] = { :element => 'span' }.merge(options[:content])
   options[:url] = {}.merge(options[:url])
   options[:ajax] = { :okText => "'Save'", :cancelText => "'Cancel'"}.merge(options[:ajax] || {})
   script = Array.new
   script << "new Ajax.InPlaceEditor("
   script << "  '#{options[:content][:options][:id]}',"
   script << "  '#{url_for(options[:url])}',"
   script << "  {"
   script << options[:ajax].map{ |key, value| "#{key.to_s}: #{value}" }.join(", ")
   script << "  }"
   script << ")"

   content_tag(
     options[:content][:element],
     options[:content][:text],
     options[:content][:options]
   ) + javascript_tag( script.join("") )
  end
  
  def random_header_image
    num = (Time.now.sec % 5) + 1
    "header_van_#{num}.jpg"
  end
end
