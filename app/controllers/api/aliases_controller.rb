module Api
  class AliasesController < ApplicationController
    before_action :set_prisoner
    before_action :set_alias, only: [:show, :update, :destroy]

    def index
      @aliases = @prisoner.aliases

      render json: @aliases
    end

    def show
      render json: @alias
    end

    def create
    end

    def update
    end

    def destroy
    end

    private

    def set_prisoner
      @prisoner = Prisoner.find(params[:prisoner_id])
    end

    def set_alias
      @alias = @prisoner.aliases.find(params[:id])
    end
  end

end
