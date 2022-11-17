# frozen_string_literal: true

module HTTP
  module Actions
    class UpdateAd < Base
      include Import[
        configuration: "hanami.action.configuration",
        command: "contexts.bulletin_board.commands.update_ad"
      ]

      def handle(req, res)
        result = command.call(**req.params.to_h)

        case result
        in Success[value]
          res.status = 200
          res.body = render_json(value, req)
        in Failure[:not_found, error]
          halt 404, { error: error }.to_json
        in Failure[:unprocessable_entity, errors]
          halt 422, { errors: errors }.to_json
        in Failure[:db_error, error]
          halt 500, { error: error }.to_json
        end
      end
    end
  end
end
