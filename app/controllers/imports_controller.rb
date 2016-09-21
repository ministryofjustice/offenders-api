class ImportsController < ApplicationController
  def new
    @last_import = Import.last
    @import = Import.new
  end

  def create
    @last_import = Import.last
    @import = Import.new(import_params)
    if @import.save
      ProcessImportJob.perform_later @import
      redirect_to new_import_path
    else
      render :new
    end
  end

  private

  def import_params
    params.require(:import).permit(:prisoners_file, :aliases_file)
  end
end
