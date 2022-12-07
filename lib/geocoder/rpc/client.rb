# frozen_string_literal: true

module Geocoder
  module RPC
    class Client
      include API

      attr_reader :queue

      def initialize(queue = nil)
        @queue = queue || create_queue
      end

      private

      def create_queue
        channel = Core::RabbitMq.channel
        channel.queue("geocoding", durable: true)
      end

      def publish(payload, options = {})
        queue.publish(
          payload,
          options.merge(
            persistent: true,
            app_id: ENV.fetch("APP_NAME"),
            headers: { request_id: Thread.current[:request_id] }
          )
        )
      end
    end
  end
end
