# Bundler => manage ruby application
source 'https://rubygems.org'
gem 'sinatra'
gem 'sinatra-reloader'
gem 'datamapper'

gem 'json', '~> 1.6' #json version fix (C9 error clear)
gem 'bcrypt'

# Board
group :production do
    gem 'pg'
    gem 'dm-postgres-adapter'
end

# for Debug, DB
group :development, :test do
    gem 'dm-sqlite-adapter'
end