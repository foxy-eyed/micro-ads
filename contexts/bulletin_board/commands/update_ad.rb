# frozen_string_literal: true

module BulletinBoard
  module Commands
    class UpdateAd
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)
      include Import[ads_repo: "contexts.bulletin_board.repositories.ad"]

      GeoDataSchemaValidator = Dry::Schema.Params do
        required(:id).value(BulletinBoard::Types::Id)
        required(:coordinates).hash do
          required(:latitude).value(Core::Types::Latitude)
          required(:longitude).value(Core::Types::Longitude)
        end
      end

      def call(params)
        data = yield validate_contract(params)
        update_ad(data.to_h)
      end

      private

      def validate_contract(params)
        GeoDataSchemaValidator.call(**params)
                              .to_monad
                              .or { |result| Failure([:unprocessable_entity, result.errors.to_h]) }
      end

      def update_ad(data)
        ad = ads_repo.find(data[:id])
        return Failure([:not_found, "Record ##{data[:id]} does not exist"]) unless ad

        Try[Sequel::Error] do
          ads_repo.update(ad.id, data[:coordinates])
        end.to_result.or { |result| Failure([:db_error, result.exception.message]) }
      end
    end
  end
end
