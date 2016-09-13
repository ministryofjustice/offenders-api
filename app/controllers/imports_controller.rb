class ImportsController < ApplicationController
  def index
    @imports = Import.order(created_at: :desc)
  end

  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      ImportProcessor.perform_async(@import.id)
      redirect_to imports_path
    else
      render :new
    end
  end

  private

  def import_params
    params.require(:import).permit(:prisoners_file, :aliases_file)
  end
end
