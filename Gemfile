source 'https://rubygems.org'
ruby '2.3.0'

gem 'carrierwave'
gem 'devise'
gem 'doorkeeper'
gem 'jquery-rails', '~> 3.1.2'
gem 'paper_trail'
gem 'pg',           '~> 0.18.2'
gem 'rails',        '4.2.6'
gem 'swagger-docs'
gem 'textacular',   '~> 3.0'
gem 'swagger-docs'

group :production, :devunicorn do
  gem 'unicorn-rails',  '2.2.0'
end

group :development do
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
