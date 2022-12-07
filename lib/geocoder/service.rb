# frozen_string_literal: true

module Geocoder
  class Error < StandardError; end

  class Service
    attr_reader :mode

    def initialize(mode = ENV["GEOCODER_MODE"])
      @mode = mode
    end

    def sync?
      %w[sync fake].include?(mode)
    end

    def geocode(id, city)
      client.geocode(id, city)
    end

    private

    def client
      @client ||= case mode
                  when "sync"
                    HTTP::Client.new
                  when "async"
                    RPC::Client.new
                  when "fake"
                    Fake::HTTPClient.new
                  end
    end
  end
end
