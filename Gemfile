source 'http://rubygems.org'

gem 'rake'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.3.20'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'composite_primary_keys'

#20140924_Graph_Add
gem 'chartkick'
gem 'groupdate'

#簡易プロファイラ
gem 'rack-mini-profiler'

#must do 'gem install nokogiri' at root befor bundle install for following gem to install
group :development, :test do
  gem 'rspec'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'spork','1.0.0rc4'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'faker-japanese'
  #capybara simulate to behavia between user and web appication
  gem 'capybara'
  #open defaut web browser when you debug
  gem 'launchy'
  #to test javascript for capybara
  gem 'selenium-webdriver'
  #to use have matcher
  gem 'rspec-collection_matchers'
  #to use debug
  #gem 'debugger', '~> 4.0.3'
  #convinience matchers
  gem 'shoulda-matchers'
#to nest_form
gem "nested_form"

gem 'devise'

gem 'jquery-turbolinks'
end

gem 'rb-readline'

gem "railroady"

#facebool,twitter ログイン
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

#taskテスト用
gem 'rake_shared_context'

#スクレイピング用gem
gem 'nokogiri'

#update insert用
gem 'upsert'

#営業日取得用
gem 'holiday_japan'

#RailsからJSに値連携
gem 'gon'

#google analyrics
gem 'google-analytics-rails'

group :production do
  gem 'newrelic_rpm'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

gem 'pry'
gem 'pry-doc'

#外部キー
gem 'foreigner'
