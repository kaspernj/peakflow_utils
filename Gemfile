source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

group :development, :test do
  gem "appraisal"
  gem "base64"
  gem "best_practice_project"
  gem "globalize", git: "https://github.com/globalize/globalize.git"
  gem "money-rails"
  gem "net-imap", "~> 0.6.2"
  gem "net-smtp"
  gem "pry-rails"
  gem "redis"
  gem "rspec-rails"
  gem "rubocop", "1.82.1"
  gem "rubocop-performance", "1.26.1"
  gem "rubocop-rails", "2.34.3"
  gem "rubocop-rspec", "3.8.0"
  gem "sidekiq"
  gem "sqlite3", platform: :ruby
  gem "tzinfo-data"
end

# Declare your gem's dependencies in peak_flow_utils.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
