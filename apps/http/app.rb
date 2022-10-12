# frozen_string_literal: true

require "hanami/api"
require "hanami/action"

module HTTP
  class App < Hanami::API
    get "/", to: Container["http.actions.fetch_ads"]
    post "/ads", to: Container["http.actions.create_ad"]
  end
end
