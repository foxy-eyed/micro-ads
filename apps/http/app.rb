# frozen_string_literal: true

require "hanami/middleware/body_parser"

module HTTP
  class App < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get "/", to: Container["http.actions.fetch_ads"]
    post "/ads", to: Container["http.actions.create_ad"]
  end
end
