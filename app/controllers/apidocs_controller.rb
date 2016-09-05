class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Single Offender ID'
      key :description, 'Single source of truth for prisoners'
      contact do
        key :name, 'single-offender-identity@digital.justice.gov.uk'
      end
    end
    tag do
      key :name, 'prisoner'
      key :description, 'Prisoners operations'
    end
    key :host, "#{ENV['HTTP_HOST']}"
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::PrisonersController,
    Prisoner,
    ErrorModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
