class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Offenders API'
      key :description, 'Single source of truth for offender information'
      contact do
        key :name, 'single-offender-identity@digital.justice.gov.uk'
      end
    end
    tag do
      key :name, 'offender'
      key :description, 'Offenders operations'
    end
    tag do
      key :name, 'identity'
      key :description, 'Identities operations'
    end
    key :host, ENV['HTTP_HOST']
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::OffendersController,
    Api::V1::IdentitiesController,
    Offender,
    Identity,
    ErrorModel,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
