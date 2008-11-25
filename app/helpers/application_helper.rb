# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include CommonEngine
  
  DEFAULT_SORT = "full_name"
  
  # Finds current user to be used throughout application
  # def current_mpd_user
  #   MpdUser.find_by_ssm_id(session[:user_id])
  # end
    
  # Performs calculation to determine offset for time remaining progress bar  
  def calc_time_remaining_bar_offset
    bar_width = 230
    percentage = 0
    
    if (!current_mpd_user.project_start_date.nil?)
      start_date = current_mpd_user.app_accepted_date
      project_date = current_mpd_user.project_start_date
      todays_date = Time.now
      
      time_left = project_date - todays_date
      total_diff = project_date - start_date
      
      percentage = (time_left.to_f / total_diff.to_f)
    end
  
      bar_offset = bar_width - (percentage * bar_width)
  end
  
  # Calculates gifts given to user
  def calc_support_received
    MpdContact.sum(:gift_amount, :conditions => ["mpd_user_id = ?", current_mpd_user.id])
  end
  
  # Calculates percentage of goal has been received by user
  def calc_goal_progress_percentage
    if !current_mpd_user.support_total.nil? and current_mpd_user.support_total > 0
      percentage = calc_support_received.to_f / current_mpd_user.support_total.to_f
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

  def error_messages_for_multiple_objects(object_names, options = {})
    options = options.symbolize_keys
    object_name_for_error = object_names[0]
    all_errors = ""
    all_errors_count = 0
    object_names.each do |object_name|
      object = instance_variable_get("@#{object_name}")
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
end
