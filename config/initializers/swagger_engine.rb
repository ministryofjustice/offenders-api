#config/initializers/swagger_engine.rb

SwaggerEngine.configure do |config|
  config.json_files = {
    v1: "public/assets/api/v1/prisoners.json"
  }
end
