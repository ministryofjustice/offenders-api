class HomeController < ApplicationController
  def show
    if current_user.admin?
      redirect_to services_path
    else
      redirect_to new_import_path
    end
  end
end
