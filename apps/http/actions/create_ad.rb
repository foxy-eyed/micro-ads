# frozen_string_literal: true

module HTTP
  module Actions
    class CreateAd < Base
      include Import[
        configuration: "hanami.action.configuration",
        command: "contexts.bulletin_board.commands.create_ad",
        auth_command: "contexts.bulletin_board.commands.auth_user"
      ]

      before :authenticate

      def handle(req, res)
        result = command.call(**req.params.to_h.merge(res[:user_data]))

        case result
        in Success[value]
          res.status = 200
          res.body = render_json(value, req)
        in Failure[:unprocessable_entity, errors]
          halt 422, { errors: errors }.to_json
        in Failure[:db_error, error]
          halt 500, { error: error }.to_json
        end
      end

      def authenticate(req, res)
        auth_result = auth_command.call(req.env["HTTP_AUTHORIZATION"])
        halt 401 unless auth_result.success?

        res[:user_data] = auth_result.value!
      end
    end
  end
end
