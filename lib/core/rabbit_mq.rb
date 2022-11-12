# frozen_string_literal: true

module Core
  module RabbitMq
    module_function

    @mutex = Mutex.new

    def connection
      @mutex.synchronize do
        @connection ||= Bunny.new.start
      end
    end

    def channel
      Thread.current[:rabbitmq_channel] ||= connection.create_channel
    end
  end
end
