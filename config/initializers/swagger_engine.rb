#config/initializers/swagger_engine.rb

SwaggerEngine.configure do |config|
  config.json_files = {
    prisoners_v1: "public/api/v1/prisoners.json",
    aliases_v1: "public/api/v1/aliases.json"
  }
end
