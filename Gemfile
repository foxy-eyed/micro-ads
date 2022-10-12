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

gem "rake"

group :test, :development do
  gem "rubocop", require: false
end
