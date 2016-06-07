class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :doorkeeper_authorize!

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "Not authorised" } }
  end
end
