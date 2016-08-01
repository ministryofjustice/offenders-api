Swagger::Docs::Config.register_apis({
  "1.0" => {
    :api_extension_type => :json,
    :api_file_path => "public/",
    :clean_directory => false,
    :base_path => "http://localhost:3000",
    :attributes => {
      :info => {
        "title" => "Prisoners API",
        "description" => "single source of truth for prisoners.",
        "contact" => "single-offender-identity@digital.justice.gov.uk",
      }
    }
  }
})
