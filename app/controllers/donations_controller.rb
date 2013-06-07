class DonationsController < ApplicationController
  layout "main"
  def index
    @designation_numbers = current_person.sp_applications.collect(&:designation_number).uniq
    @designation_numbers.compact!
    @donations = @designation_numbers.present? ? SpDonation.find(:all, :conditions => {:designation_number => @designation_numbers}, :order => 'donation_date desc') : []
  end

end
