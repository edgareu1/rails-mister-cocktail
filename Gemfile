source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript.
# Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Makes it easy and painless to work with XML and HTML from Ruby
gem 'nokogiri', '>= 1.11.0'
# Framework for handling and responding to web requests
gem "actionpack", ">= 6.0.3.5"
# Facilitates the creation and use of business objects whose data requires
# persistent storage to a database
gem "activerecord", ">= 6.0.3.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rspec-rails', '4.0.0.beta3', group: [ :test ]
gem 'rails-controller-testing', group: [ :test ]

# Style
gem 'autoprefixer-rails'
gem 'font-awesome-sass', '~> 5.12.0'
gem 'simple_form'

# Save keys in a secure way
gem 'dotenv-rails', groups: [:development, :test]

# Cloudinary & Environment
gem 'cloudinary', '~> 1.12.0'

# Pagination
gem 'will_paginate', '~> 3.3.0'
gem 'will_paginate-bootstrap4'

# Search bar
gem 'pg_search', '~> 2.3.0'

# Seed fake data
gem 'faker'

# Render PUT forms with AJAX
gem 'turbolinks_render'

# To pass variables from a controller to a JS file
gem 'gon'
