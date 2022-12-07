# frozen_string_literal: true

module Geocoder
  module HTTP
    module API
      def geocode(_id, city)
        request(:post, "coordinates", { city: city })
      end
    end
  end
end
