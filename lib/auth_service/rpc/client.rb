# frozen_string_literal: true

module AuthService
  module RPC
    class Client
      include API

      def initialize(queue = nil, reply_queue = nil)
        @queue = queue || create_queue
        @reply_queue = reply_queue || create_reply_queue
        @lock = Mutex.new
        @condition = ConditionVariable.new
      end

      def self.fetch
        Thread.current["auth_service.rpc.client"] ||= new.start
      end

      def start
        @consumer = reply_queue.subscribe
        self
      end

      def on_reply
        consumer.on_delivery do |delivery_info, properties, payload|
          if properties[:correlation_id] == @correlation_id
            lock.synchronize do
              yield delivery_info, properties, payload if block_given?
              condition.signal
            end
          end
        end
      end

      private

      attr_reader :queue, :reply_queue, :lock, :condition, :consumer
      attr_writer :correlation_id

      def create_queue
        channel = Core::RabbitMq.channel
        channel.queue("auth", durable: true)
      end

      def create_reply_queue
        channel = Core::RabbitMq.channel
        channel.queue("amq.rabbitmq.reply-to")
      end

      def publish(payload, options = {})
        self.correlation_id = SecureRandom.uuid

        lock.synchronize do
          queue.publish(
            payload,
            options.merge(
              app_id: ENV.fetch("APP_NAME"),
              reply_to: reply_queue.name,
              correlation_id: @correlation_id,
              headers: { request_id: Thread.current[:request_id] }
            )
          )
          condition.wait(lock)
        end
      end
    end
  end
end
