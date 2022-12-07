# frozen_string_literal: true

module AuthService
  module RPC
    module API
      def auth(token)
        payload = { token: token }.to_json
        publish(payload, type: "request-auth")
      end
    end
  end
end
