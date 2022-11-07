# frozen_string_literal: true

module Geocoder
  class API
    include Import[client: "geocoder.client"]

    def coordinates(city)
      client.request(:post, "coordinates", { city: city })
    end
  end
end
