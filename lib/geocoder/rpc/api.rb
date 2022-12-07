# frozen_string_literal: true

module Geocoder
  module RPC
    module API
      def geocode(id, city)
        payload = { id: id, city: city }.to_json
        publish(payload, type: "geocode")
      end
    end
  end
end
