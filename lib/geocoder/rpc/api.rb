# frozen_string_literal: true

module Geocoder
  module RPC
    class API
      include Import[client: "geocoder.rpc.client"]

      def geocode_later(ad)
        payload = { id: ad.id, city: ad.city }.to_json
        client.publish(payload, type: "geocode")
      end
    end
  end
end
