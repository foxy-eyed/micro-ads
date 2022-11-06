# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.0"

# dependency management
gem "dry-system", "0.25"
gem "zeitwerk"

# load env variables
gem "dotenv"

# transport
gem "hanami-api"
gem "hanami-controller", git: "https://github.com/hanami/controller.git", tag: "v2.0.0.beta1"
gem "hanami-validations", git: "https://github.com/hanami/validations.git", tag: "v2.0.0.beta1"
gem "puma"

# business logic
gem "dry-monads", "1.3"
gem "dry-schema", "1.9"

# persistence layer
gem "dry-struct", "1.0"
gem "dry-types", "1.5"
gem "pg"
gem "sequel"

# http calls
gem "faraday"
gem "faraday-retry"

# other
gem "rake"

group :test, :development do
  gem "faker"
  gem "rubocop", require: false
  gem "rubocop-rspec"
end

group :test do
  gem "database_cleaner-sequel"
  gem "factory_bot"
  gem "rack-test"
  gem "rspec"
  gem "simplecov", require: false
end
