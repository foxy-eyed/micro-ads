# frozen_string_literal: true

module BulletinBoard
  module Commands
    class AuthUser
      include Dry::Monads[:result]

      def call(auth_header)
        result = nil
        authenticator.on_reply do |_delivery_info, _properties, payload|
          auth_data = JSON.parse(payload)
          result = auth_data["status"] == "success" ? Success(user_id: auth_data["user_id"]) : Failure([:unauthorized])
        end
        authenticator.auth(auth_header)
        result
      end

      private

      def authenticator
        @authenticator ||= AuthService::RPC::Client.fetch
      end
    end
  end
end
