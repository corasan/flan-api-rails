source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

gem 'bootsnap', require: false
gem 'firebase-auth-rails'
gem 'jwt'
gem 'nokogiri', '>= 1.13.3'
gem 'pg', '>= 1.3.4'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'firebase_id_token', '~> 2.5.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'spring'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'solargraph'
end
