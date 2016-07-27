class ImportsController < ApplicationController
  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)

    if @import.save
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def import_params
    params.require(:import).permit(
      :file
    )
  end
end
