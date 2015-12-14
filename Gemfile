source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'faker'
gem 'sidekiq'
gem 'puma'
gem 'sinatra', require: nil

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'

  gem 'spring-commands-rspec'
  gem 'rspec-rails', '2.99'
  gem 'guard-rspec'

  gem 'fabrication-rails'
end

group :test do
  gem 'shoulda-matchers', '3.0.1'
  gem 'database_cleaner', '1.2.0'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end
