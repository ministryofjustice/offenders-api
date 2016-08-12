class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit

  protected

  def authorise_admin!
    redirect_to root_url, notice: 'Must be signed in as an admin user' unless current_user.admin?
  end
end
