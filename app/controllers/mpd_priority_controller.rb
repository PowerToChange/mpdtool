class MpdPriorityController < ApplicationController
  skip_before_filter CAS::Filter

  def rate
    @mpd_contact = MpdContact.find(params[:id])
    MpdPriority.delete_all(["rateable_type = 'MpdContact' AND rateable_id = ? AND mpd_user_id = ?", 
      @mpd_contact.id, current_mpd_user.id])
    @mpd_contact.add_priority MpdPriority.new(:priority => params[:priority], 
      :mpd_user_id => current_mpd_user.id)
  end

end