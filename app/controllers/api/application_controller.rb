module Api
  class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    before_action :doorkeeper_authorize!

    def doorkeeper_unauthorized_render_options(*)
      { json: { error: "Not authorised" } }
    end
  end
end
