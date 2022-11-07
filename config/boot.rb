# frozen_string_literal: true

require "bundler/setup"
require "dotenv"
require_relative "../system/container"

Dotenv.load(".env", ".env.#{ENV['APP_ENV']}")
Bundler.require(:default, ENV["APP_ENV"])

Container.finalize! unless ENV["APP_ENV"] == "test"
