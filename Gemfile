source 'http://rubygems.org'

gem 'rails', '3.1.0.beta1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Asset template engines
gem 'sass'
gem 'json_pure'
gem 'coffee-script'
gem 'uglifier'
gem 'whenever', :require => false
gem 'haml-rails'
gem 'jquery-rails'
gem 'rest-client', :require => 'rest_client'
gem 'delayed_job'

group :test, :development do
  gem 'rspec-rails'
  gem 'ruby-debug19'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'growl'
  gem 'rails3-generators'
end

group :test do
  gem 'factory_girl_rails', '~> 1.0.1'
  gem 'webmock',            '~> 1.6.2'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
end
