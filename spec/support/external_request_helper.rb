# frozen_string_literal: true

module ExternalRequestHelper
  def connection
    Faraday.new do |conn|
      conn.adapter(:test, stubs)
      conn.request :json
      conn.response :json, content_type: "application/json"
    end
  end

  def stubs
    @stubs ||= Faraday::Adapter::Test::Stubs.new
  end
end
