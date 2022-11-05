# frozen_string_literal: true

module Geocoder
  class API
    class Error < StandardError; end

    include Import[client: "geocoder.client"]

    def coordinates(city)
      request(:post, "coordinates", { city: city })
    end

    private

    def request(verb, path, params = {})
      response = client.send(verb, path, params)
      status = response.status
      body = response.body
      raise Error, "[Geocoder]: #{status} — #{body}" unless status == 200

      body
    rescue Faraday::Error => e
      raise Error, "[Geocoder]: #{e.message}"
    end
  end
end
