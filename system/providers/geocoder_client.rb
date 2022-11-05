# frozen_string_literal: true

Container.register_provider(:geocoder_client) do
  start do
    connection = Faraday.new(url: ENV.fetch("GEOCODER_API_URL")) do |conn|
      conn.request :retry, { retry_statuses: [500], interval: 0.05 }
      conn.request :json
      conn.response :json
    end

    register("geocoder.client", connection)
  end
end
