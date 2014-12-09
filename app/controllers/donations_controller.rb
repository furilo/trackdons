class DonationsController < ApplicationController
  before_filter :set_new_donation, only: :new
  
  def index
    if params.has_key?(:project_id)
      project = Project.friendly.find(params[:project_id])
      @donations = Donation.where(project_id: project.id)
    else
      @donations = Donation.all
    end
  end

  def new
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def create
    unless logged_in?
      save_donation_to_cookie(donation_params)
      cookie_donation
      redirect_to signup_path
    else
      donation_save(donation_params)
      if cookies[:donation]
        cookies.delete(:donation)
      end
    end
  end

  private

    def donation_params
      params.require(:donation).permit(
        :quantity, 
        :currency, 
        :date, 
        :comment, 
        :quantity_privacy,
        :project_id,
        :project_name, 
        :project_description, 
        :project_url)
    end

    def save_donation_to_cookie(donation_params)
      cookies[:donation] = { 
        :quantity_cents       => donation_params[:quantity_cents],
        :currency             => donation_params[:currency],
        :date                 => donation_params[:date],
        :project_id           => donation_params[:project_id],
        :project_name         => donation_params[:project_name],
        :project_description  => donation_params[:project_description],
        :project_url          => donation_params[:project_url],
        :comment              => donation_params[:comment],
        :quantity_privacy     => donation_params[:quantity_privacy],
        :user_id              => donation_params[:user_id]
      }.to_json
    end

end
