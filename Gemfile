source 'https://rubygems.org'
ruby '2.3.0'

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
gem 'sentry-raven'
gem 'sidekiq'
gem 'swagger-blocks'
gem 'swagger_engine'
gem 'uglifier'
gem 'whenever', require: false

group :production, :devunicorn do
  gem 'unicorn-rails', '2.2.0'
end

group :development do
  gem 'rubocop', '0.42', require: false
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug'
  gem 'rspec-rails', '~> 3.4'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner',   '~> 1.5.3'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-mocks',        '~> 3.4.1'
  gem 'shoulda-matchers',   '~> 2.8.0', require: false
  gem 'simplecov', require: false
end
