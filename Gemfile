source 'https://ruby.taobao.org/'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
gem "mongoid"
gem "mongoid-tree"
gem 'database_cleaner'

gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'

gem "responders"
gem "devise"
gem "httparty"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sidekiq'
gem 'sinatra', :require => nil

# Use Uglifier as compressor for JavaScript assets
# Use CoffeeScript for .coffee assets and views
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
gem 'jbuilder'
# Use jquery as the JavaScript library
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'rake'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'settingslogic'
gem 'puma'
gem 'mina'
gem 'mina-sidekiq', :require => false
gem 'mina-puma', :require => false
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "rspec-rails"
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem "factory_girl_rails"
  gem "faker"
  gem "shoulda-matchers"
end
