# frozen_string_literal: true

module Geocoder
  module RPC
    class Client
      attr_reader :queue

      def initialize(queue = nil)
        @queue = queue || create_queue
      end

      def publish(payload, options = {})
        queue.publish(payload, options.merge(persistent: true, app_id: "ads"))
      end

      private

      def create_queue
        channel = Core::RabbitMq.channel
        channel.queue("geocoding", durable: true)
      end
    end
  end
end
