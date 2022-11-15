# frozen_string_literal: true

require "hanami/middleware/body_parser"

module HTTP
  class App < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get "/", to: Container["http.actions.fetch_ads"]
    post "/ads", to: Container["http.actions.create_ad"]
    patch "/ads/:id", to: Container["http.actions.update_ad"]
  end
end
