Swagger::Docs::Config.register_apis({
  "1.0" => {
    :api_extension_type => :json,
    :api_file_path => "public/docs/",
    :clean_directory => false,
    :parent_controller => Api::ApplicationController,
    :attributes => {
      :info => {
        "title" => "Prisoners API",
        "description" => "single source of truth for prisoners.",
        "contact" => "singleoffenderidentity@digital.jsutice.gov.uk",
      }
    }
  }
})
