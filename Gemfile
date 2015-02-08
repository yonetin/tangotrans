source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'activerecord'
gem "sinatra-activerecord", :require => "sinatra/activerecord"
gem 'rake'
gem 'nokogiri'

group :production do
  gem 'pg'
end

group :development do
  gem 'sqlite3'
  gem "sinatra-reloader"
  gem "foreman"
end

