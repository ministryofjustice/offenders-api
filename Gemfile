source 'https://rubygems.org'
# ruby '2.3.0'

gem 'active_model_serializers'
gem 'carrierwave'
gem 'devise'
gem 'doorkeeper'
gem 'haml-rails'
gem 'govuk_elements_rails'
gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder.git'
gem 'govuk_frontend_toolkit'
gem 'govuk_template', '0.18.0'
gem 'jquery-rails'
gem 'kaminari'
gem 'paper_trail'
gem 'pg'
gem 'rails', '4.2.7.1'
gem 'sass-rails'
gem 'secure_headers'
gem 'sentry-raven'
gem 'sidekiq'
gem 'swagger-blocks'
gem 'swagger_engine'
gem 'uglifier'
gem 'whenever', require: false

group :production do
  gem 'unicorn-rails', '2.2.0'
end

group :development do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'rubocop', require: false
  gem 'web-console'
end

group :development, :test do
  gem 'awesome_print'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-mocks'
  gem 'rspec-rails'
  gem 'shoulda-matchers',   '~> 2.8.0', require: false
  gem 'simplecov', require: false
end
