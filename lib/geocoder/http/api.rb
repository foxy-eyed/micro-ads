# frozen_string_literal: true

module Geocoder
  module HTTP
    class API
      include Import[client: "geocoder.http.client"]

      def coordinates(city)
        client.request(:post, "coordinates", { city: city })
      end
    end
  end
end
