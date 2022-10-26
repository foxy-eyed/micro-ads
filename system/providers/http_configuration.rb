# frozen_string_literal: true

Container.register_provider(:http_configuration) do
  prepare do
    require "hanami/action"

    hanami_action_config = Hanami::Action::Configuration.new do |config|
      config.default_request_format = :json
      config.default_response_format = :json
    end

    register("hanami.action.configuration", hanami_action_config)
  end
end
