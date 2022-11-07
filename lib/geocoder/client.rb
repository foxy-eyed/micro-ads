# frozen_string_literal: true

module Geocoder
  class Client
    class Error < StandardError; end

    attr_reader :connection

    def initialize(connection = nil)
      @connection = connection || build_connection
    end

    def request(verb, path, params = {})
      response = connection.send(verb, path, params)
      status = response.status
      body = response.body
      raise Error, "[Geocoder]: #{status} — #{body}" unless status == 200

      body
    rescue Faraday::Error => e
      raise Error, "[Geocoder]: #{e.message}"
    end

    private

    def build_connection
      Faraday.new(url: ENV.fetch("GEOCODER_API_URL")) do |conn|
        conn.request :retry, { retry_statuses: [500], interval: 0.05 }
        conn.request :json
        conn.request :json, content_type: "application/json"
      end
    end
  end
end
