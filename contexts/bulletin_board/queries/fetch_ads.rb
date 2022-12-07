# frozen_string_literal: true

module BulletinBoard
  module Queries
    class FetchAds
      include Dry::Monads[:result, :try]
      include Import[ads_repo: "contexts.bulletin_board.repositories.ad"]

      def call(params = {})
        Try[Sequel::Error] do
          dataset = ads_repo.all(params)
          ads = dataset.to_a
          { collection: ads, stats: { pages: dataset.pages, total: dataset.total } }
        end.to_result.or { |result| Failure([:db_error, result.exception.message]) }
      end
    end
  end
end
