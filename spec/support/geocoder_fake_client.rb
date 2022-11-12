# frozen_string_literal: true

class GeocoderFakeClient
  def initialize
    @client = Geocoder::HTTP::Client.new(fake_connection)
  end

  def request(*args)
    client.request(*args)
  end

  private

  attr_reader :client

  def fake_connection
    @fake_connection ||= Faraday.new do |conn|
      conn.adapter(:test, stubs)
      conn.request :json
      conn.response :json, content_type: "application/json"
    end
  end

  def stubs
    @stubs ||= Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("/coordinates", { city: "Limassol" }.to_json) do
        [200, { "Content-Type" => "application/json" }, { latitude: 34.707130, longitude: 33.022617 }.to_json]
      end

      stub.post("/coordinates", { city: "Unknown" }.to_json) do
        [404, { "Content-Type" => "application/json" }, { error: "Cannot locate 'Unknown'" }.to_json]
      end
    end
  end
end
