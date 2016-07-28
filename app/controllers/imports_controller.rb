class ImportsController < ApplicationController
  def index
    @imports = Import.order(created_at: :desc)
  end

  def new
    @import = Import.new
  end

  def create
    result = ImportPrisoners.new(import_params).call
    @import = result.import

    if result.success?
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end
end
