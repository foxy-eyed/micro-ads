# frozen_string_literal: true

module BulletinBoard
  module Commands
    class CreateAd
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)
      include Import[
                ads_repo: "contexts.bulletin_board.repositories.ad",
                geocoder_api: "geocoder.api"
              ]

      AdSchemaValidator = Dry::Schema.Params do
        required(:user_id).value(BulletinBoard::Types::Id)
        required(:title).value(BulletinBoard::Types::AdTitle)
        required(:description).value(BulletinBoard::Types::AdDescription)
        required(:city).value(BulletinBoard::Types::AdCity)
      end

      def call(params)
        data = yield validate_contract(params)
        ad = yield create_ad(data.to_h)
        fetch_coordinates(ad)
      end

      private

      def validate_contract(params)
        AdSchemaValidator.call(**params)
                         .to_monad
                         .or { |result| Failure([:unprocessable_entity, result.errors.to_h]) }
      end

      def create_ad(data)
        Try[Sequel::Error] { ads_repo.create(data) }.to_result
                                                    .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def fetch_coordinates(ad)
        coordinates = geocoder_api.coordinates(ad.city)
        updated_ad = ads_repo.update(ad.id, coordinates)
        Success(updated_ad)
      rescue Geocoder::API::Error
        # Not for production (normally would do async API call).
        # Decided to return an ad object even without coordinates.
        # Also need to track exceptions (at least for ex. send to Sentry).
        Success(ad)
      end
    end
  end
end
