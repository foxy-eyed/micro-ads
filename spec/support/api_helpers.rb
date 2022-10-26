# frozen_string_literal: true

module ApiHelpers
  include Rack::Test::Methods

  def app
    @app ||= HTTP::App.new
  end

  def response_status
    last_response.status
  end

  def response_json
    JSON.parse(last_response.body)
  end
end
