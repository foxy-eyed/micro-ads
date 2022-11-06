# frozen_string_literal: true

require "simplecov_profile"
SimpleCov.start "custom_profile"

ENV["APP_ENV"] ||= "test"

require_relative "../config/boot"
Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

require "dry/system/stubs"
Container.enable_stubs!
Container.stub("geocoder.client", GeocoderFakeClient.new)
Container.finalize!

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include Dry::Monads[:result]

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random
  Kernel.srand config.seed

  config.include ApiHelpers, type: :request
end
