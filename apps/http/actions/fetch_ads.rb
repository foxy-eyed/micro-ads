# frozen_string_literal: true

module HTTP
  module Actions
    class FetchAds < Base
      include Import[
        configuration: "hanami.action.configuration",
        query: "contexts.bulletin_board.queries.fetch_ads"
      ]

      params do
        optional(:page).filled(:integer, gteq?: 1)
        optional(:per_page).filled(:integer, gteq?: 1, lteq?: 100)
      end

      def handle(req, res)
        result = query.call(**req.params.to_h)

        case result
        in Success[value]
          res.status = 200
          res.body = render_json(value, req)
        in Failure[_, errors]
          halt 422, { errors: errors }.to_json
        end
      end
    end
  end
end
