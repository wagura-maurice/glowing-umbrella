source 'https://rubygems.org'
ruby "2.3.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'
# Stuff that rails 4 gets rid of
gem 'actionpack-action_caching', '~>1.0.0'
gem 'actionpack-page_caching', '~>1.0.0'
#gem 'actionpack-xml_parser', '~>1.0.0' # Only need this gem if we accept XML in the request body
gem 'actionview-encoded_mail_to', '~>1.0.4'
gem 'activerecord-session_store', '~>0.1.0'
gem 'activeresource', '~>4.0.0.beta1'
#gem 'protected_attributes', '~>1.0.1'
gem 'rails-observers', '~>0.1.1'

gem 'safe_attributes'
gem 'responders', '~> 2.0'

# Use postgresql as the database for Active Record
gem 'pg', '0.21.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

gem 'sorcery', '~>0.9.0'
gem 'phony_rails'
gem "json"
gem "curb" #required by AfricasTalking
gem "twitter-text"
gem 'newrelic_rpm'
gem 'rails_12factor', group: :production # Required for Heroku
gem 'dalli'
gem 'memcachier'
gem 'em-http-request', '~> 1.1.5'
gem 'httparty'
gem 'puma'
gem 'connection_pool' # So that memcached can have a pool
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails'
gem 'groupdate'
gem 'chartkick', "3.3.0"
gem 'rollbar'
gem 'roo', '~> 2.1.0'
gem 'dropbox-sdk'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'bcrypt'
gem 'sendgrid-ruby'
gem 'aws-sdk', '~> 2.3'
gem 'sidekiq', '~> 4.0.0'
gem 'redis'
gem 'reports_kit', '~> 0.7.1'
gem "rest-client"
gem 'haml-rails'

# API
gem 'rails-api'
gem 'active_model_serializers', '~> 0.10.0'

group :development do
	gem 'capistrano', '~> 3.0'
	gem 'capistrano-rails', '~> 1.2'
	gem 'capistrano-passenger', '~> 0.2.0'

	# Add this if you're using rbenv
	# gem 'capistrano-rbenv', '~> 2.1'

	# Add this if you're using rvm
	gem 'capistrano-rvm', github: "capistrano/rvm"
end