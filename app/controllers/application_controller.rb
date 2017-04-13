class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :set_paper_trail_whodunnit

  protected

  def authorise_admin!
    redirect_to root_url, notice: 'Must be signed in as an admin user' unless current_user.admin?
  end

  def authenticate_user!
    redirect_to new_session_path unless sso_identity
  end

  def current_user
    @current_user ||= sso_identity&.user
  end
  helper_method :current_user

  def user_signed_in?
    sso_identity.present?
  end
  helper_method :user_signed_in?

  def sso_identity
    @sso_identity ||= set_sso_identity
  end

  def set_sso_identity
    session[:sso_data] && SSO::Identity.from_session(session[:sso_data])
  end
end
